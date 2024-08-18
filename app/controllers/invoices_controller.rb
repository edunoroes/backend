class InvoicesController < ApplicationController
  before_action :authenticate_user!
  require 'axlsx'

  def index
    invoices = Invoice.where(user_id: current_user.id)
    invoices = invoices.where('invoice_number LIKE ?', "%#{params[:invoice_number]}%") if params[:invoice_number].present?

    render json: {status: 'SUCCESS', data: invoices}, status: :ok
  end

  def report
    invoices = Invoice.where(user_id: current_user.id)
    invoices = invoices.where('invoice_number LIKE ?', "%#{params[:invoice_number]}%") if params[:invoice_number].present?

    # Cria o arquivo Excel e salva na pasta tmp
    file_path = generate_and_save_excel_report(invoices)

    # Envia o arquivo como resposta para download
    send_file file_path,
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              disposition: 'attachment',
              filename: 'Invoices_Report.xlsx'

    # Remove o arquivo após envio
    File.delete(file_path) if File.exist?(file_path)
  end

  private

  def generate_and_save_excel_report(invoices)
    # Define o caminho para a pasta tmp
    file_path = Rails.root.join('tmp', 'Invoices_Report.xlsx')

    # Cria o pacote Excel e salva no arquivo especificado
    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Invoices Report") do |sheet|
      # Cabeçalhos
      sheet.add_row ["Invoice Number", "Series", "Emitent", "Recipient", "Product Name", "NCM", "CFOP", "Unit", "Quantity", "Unit Price", "ICMS", "IPI", "PIS", "COFINS"]

      invoices.each do |invoice|
        # Adiciona uma linha para cada produto
        invoice.products.each do |product|
          # Adiciona uma linha com informações do produto e impostos
          sheet.add_row [
            invoice.invoice_number,
            invoice.series,
            invoice.emitent.name,
            invoice.recipient.name,
            product.name,
            product.ncm,
            product.cfop,
            product.commercial_unit,
            product.commercial_quantity,
            product.unit_value,
            invoice.taxes.first&.icms_value || 0,
            invoice.taxes.first&.ipi_value || 0,
            invoice.taxes.first&.pis_value || 0,
            invoice.taxes.first&.cofins_value || 0
          ]
        end
      end
    end

    # Salva o pacote no arquivo especificado
    package.serialize(file_path)

    file_path
  end
end
