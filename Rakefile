task :build do
  system("docker build -t geobin .")
end

task :run do
  system("docker run -i -t --rm -p 5432:5432 -p 8080:8080 geobin")
end

task :bash do
  exec("docker run -i -t --rm geobin /bin/bash")
end

task :psql do
  exec("PGPASSWORD=geobin psql --port 5433 --host 127.0.0.1 --username geobin --no-password")
end