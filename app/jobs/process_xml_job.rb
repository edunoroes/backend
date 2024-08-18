class ProcessXmlJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    # Lógica para processar o arquivo XML
    # Exemplo de leitura do conteúdo do arquivo:
    content = File.read(file_path)
    # Processamento do conteúdo...
  ensure
    # Remove o arquivo temporário após o processamento
    # File.delete(file_path) if File.exist?(file_path)
  end
end
