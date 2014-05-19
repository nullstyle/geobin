task :build do
  system("docker build -t nullstyle/geobin .")
end

task :run do
  system("docker run -i -t --rm -p 5433:5433 -p 8080:8080 nullstyle/geobin")
end

task :bash do
  exec("docker run -i -t --rm nullstyle/geobin /bin/bash")
end

task :psql do
  exec("PGPASSWORD=geobin psql --port 5433 --host localdocker --username geobin --no-password")
end