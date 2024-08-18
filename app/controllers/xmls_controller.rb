class XmlsController < ApplicationController
  before_action :authenticate_user!
  def upload
    
    # Verifica se o arquivo foi enviado
    if params[:file].present?
      # Salva o arquivo em uma pasta temporária
      
      file = params[:file]
      file_path = Rails.root.join('tmp', 'uploads', file.original_filename)

      # Grava o arquivo no sistema de arquivos
      File.open(file_path, 'wb') do |f|
        f.write(file.read)
      end

      # Envia o job para processamento
      ProcessXmlJob.perform_later(file_path.to_s, current_user.id)

      render json: { message: 'Arquivo recebido e job iniciado.' }, status: :ok
    else
      render json: { error: 'Nenhum arquivo enviado.' }, status: :unprocessable_entity
    end
  end
end
