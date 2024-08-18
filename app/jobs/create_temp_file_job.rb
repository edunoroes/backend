class CreateTempFileJob < ApplicationJob
  queue_as :default

  def perform
    # Define o caminho do arquivo temporário
    temp_file_path = Rails.root.join('tmp', 'eduardo.txt')

    # Cria e escreve algo no arquivo
    File.open(temp_file_path, 'w') do |file|
      file.write("Este é um arquivo temporário chamado eduardo.")
    end

    Rails.logger.info "Arquivo temporário criado: #{temp_file_path}"
  end
end