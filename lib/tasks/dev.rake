require "tty-spinner"

DEFAULT_PASSWORD = "123456"

namespace :dev do
  desc "Configura o ambiente de desenvolviment"
  task setup: :environment do
    if Rails.env.development?
      tasks = [
        { command: "db:drop", start: "Deletando banco de dados...", end: "Deletado com sucesso!" },
        { command: "db:create", start: "Criando o banco de dados...", end: "Criado com sucesso!" },
        { command: "db:migrate", start: "Migrando o banco de dados...", end: "Migrado com sucesso!" },
        { command: "dev:add_default_admin", start: "Cadastrando Administrador...", end: "Cadastrado com sucesso!" },
        { command: "dev:add_default_user", start: "Cadastrando Usuário Padrão...", end: "Cadastrados com sucesso!" }
      ]

      tasks.each do |task|
        show_spinner(task[:start], task[:end]) { system("rails #{task[:command]} > /dev/null ") }
      end
    else
      puts "Você está em ambiente de produção!!! Animal!!!"
    end
  end

  # Devise não aceita o find_or_create_by, a própria gem faz a verificação se o usuário existe ou não
  desc "Cadastra o usuário administrador"
  task add_default_admin: :environment do
    Admin.create!(email: "administrador@email.com", password: DEFAULT_PASSWORD, password_confirmation: DEFAULT_PASSWORD)
  end

  desc "Cadastra o usuário padrão"
  task add_default_user: :environment do
    User.create!(email: "user@email.com", password: DEFAULT_PASSWORD, password_confirmation: DEFAULT_PASSWORD)
  end

  private

  def show_spinner(msg_begin, msg_end)
    spinner =TTY::Spinner.new("[:spinner] #{msg_begin}", format: :bouncing_ball)
    spinner.auto_spin
    yield
    spinner.success("#{msg_end}")
  end
end
