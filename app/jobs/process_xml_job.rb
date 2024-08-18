class ProcessXmlJob < ApplicationJob
  queue_as :default
  require 'nokogiri'

  def perform(file_path, user_id)
    # Carregar o XML
    xml_file = File.read(file_path)
    doc = Nokogiri::XML(xml_file)
    # Extrair dados da nota fiscal
    nfe = doc.at_xpath('//xmlns:infNFe')
    ide = nfe.at_xpath('xmlns:ide')
    emit = nfe.at_xpath('xmlns:emit')
    dest = nfe.at_xpath('xmlns:dest')

    emissor = TaxEntity.where(cnpj: emit.at_xpath('xmlns:CNPJ').content).first
    receptor = TaxEntity.where(cnpj: dest.at_xpath('xmlns:CNPJ').content).first

    if emissor.present? 
      emissor_id = emissor.id
    else
      emissor = TaxEntity.create!(
        cnpj: emit.at_xpath('xmlns:CNPJ').content,
        name: emit.at_xpath('xmlns:xNome').content,
        address: emit.at_xpath('xmlns:enderEmit/xmlns:xLgr').content,
        number: emit.at_xpath('xmlns:enderEmit/xmlns:nro').content,
        neighborhood: emit.at_xpath('xmlns:enderEmit/xmlns:xBairro').content,
        city: emit.at_xpath('xmlns:enderEmit/xmlns:xMun').content,
        state: emit.at_xpath('xmlns:enderEmit/xmlns:UF').content,
        postal_code: emit.at_xpath('xmlns:enderEmit/xmlns:CEP').content,
        )
      emissor_id = emissor.id
    end  

    if receptor.present? 
      receptor_id = receptor.id
    else
      receptor = TaxEntity.create!(
        cnpj: dest.at_xpath('xmlns:CNPJ').content,
        name: dest.at_xpath('xmlns:xNome').content,
        address: dest.at_xpath('xmlns:enderDest/xmlns:xLgr').content,
        number: dest.at_xpath('xmlns:enderDest/xmlns:nro').content,
        neighborhood: dest.at_xpath('xmlns:enderDest/xmlns:xBairro').content,
        city: dest.at_xpath('xmlns:enderDest/xmlns:xMun').content,
        state: dest.at_xpath('xmlns:enderDest/xmlns:UF').content,
        postal_code: dest.at_xpath('xmlns:enderDest/xmlns:CEP').content,
        )
      receptor_id = receptor.id
    end  

    # Criar objetos correspondentes
    nota_fiscal = Invoice.create!(
      user_id: user_id,
      invoice_number: ide.at_xpath('xmlns:nNF').content,
      series: ide.at_xpath('xmlns:serie').content,
      issue_datetime: ide.at_xpath('xmlns:dhEmi').content,
      emitent_id: emissor_id,
      recipient_id: receptor_id
    )
    

    # Iterar sobre os produtos
    imposto_total = nfe.xpath('//xmlns:total')
    nfe.xpath('//xmlns:det').each do |det|
      prod = det.at_xpath('xmlns:prod')
      imposto = det.at_xpath('xmlns:imposto')
      
      produto = Product.create!(
        name: prod.at_xpath('xmlns:xProd').content,
        ncm: prod.at_xpath('xmlns:NCM').content,
        cfop: prod.at_xpath('xmlns:CFOP').content.to_f,
        commercial_unit: prod.at_xpath('xmlns:vUnCom').content.to_f,
        commercial_quantity: prod.at_xpath('xmlns:vProd').content.to_f,
        unit_value:  prod.at_xpath('xmlns:vUnTrib').content.to_f,
        invoice: nota_fiscal
      )
      
      


      Taxe.create!(
        icms_value: imposto.at_xpath('xmlns:ICMS/xmlns:ICMS00/xmlns:vICMS').content.to_f,
        ipi_value: imposto_total.at_xpath('xmlns:ICMSTot/xmlns:vIPI').content.to_f,
        pis_value: imposto_total.at_xpath('xmlns:ICMSTot/xmlns:vPIS').content.to_f,
        cofins_value: imposto_total.at_xpath('xmlns:ICMSTot/xmlns:vCOFINS').content.to_f,
        product_id: produto.id
      )
    end
  ensure
    # Remove o arquivo temporário após o processamento
    #File.delete(file_path) if File.exist?(file_path)
  end
end
