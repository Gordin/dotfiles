source ~/.config/zsh/work.env

# alias wgit="GIT_SSH_COMMAND='ssh -i  ~/.ssh/id_work' git -c user.name=andreasguthstuditemps -c user.email=andreas.guth@studitemps.de $@"

# WORK START #
alias club='cd ~/work/clubhouse'
alias base='cd ~/work/studibase/app/functions'
clubhouse() {
  docker exec -it clubhouse "$@"
}
alias clubhouse_server='clubhouse bundle exec hanami server --host 0.0.0.0 --port 9292'
alias clubhouse_shell='clubhouse bundle exec hanami c'
# alias cspec='clubhouse bundle exec rspec'
alias rcspec='clubhouse bundle exec rescue rspec'
alias clubhouse_migrate="clubhouse bash -c 'HANAMI_ENV=development bundle exec hanami db migrate'"
alias clubhouse_prepare_test="clubhouse bash -c 'HANAMI_ENV=test bundle exec rake db:parallel_test:prepare'"
alias clubhouse_bundle="clubhouse bash -c 'bundle install --jobs=20; bundle pack --all'"
# alias cspec="clubhouse bash -c 'RACK_ENV=test parallel_rspec spec'"

certi() {
  docker exec -it certification "$@"
}
# sbase() { docker exec -itu root studibase "$@" }
fbase_testing_config() {
  bash -c "\
    cd ~/work/studibase/app/functions;\
    cp .runtimeconfig.json .runtimeconfig.json.bak;\
    cp .runtimeconfig_testing.json .runtimeconfig.json"
}

fbase_restore_config() {
  bash -c "\
    cd ~/work/studibase/app/functions;\
    cp .runtimeconfig.json.bak .runtimeconfig.json"
}
sbase() {
    docker exec -it studibase "$@"
}
fbase() {
	rev=$(cd /home/aguth/work/studibase/; echo $(git rev-parse HEAD))
    sbase bash -c "export GIT_REF=$rev; export LINEARB_API_KEY=$LINEARB_API_KEY; cd functions; $*"; return $?
}
alias fstaging='fbase firebase use staging && fbase'
alias fprod='fbase firebase use production && fbase'
ftest() {
  fbase_testing_config && fbase npm run test "$@"
  fbase_restore_config
}
fdebug() {
  fbase_testing_config && fbase npm run debug "$@"
  fbase_restore_config
}
alias anzeigen='docker exec -it anzeigenschaltung'
alias an_bundle="anzeigen bash -c 'bundle install --jobs=20; bundle pack --all'"
alias an_shell='anzeigen bundle exec hanami c'
alias an_server='anzeigen bundle exec hanami server --host 0.0.0.0 -p 2301'
alias an_migrate="anzeigen bash -c 'HANAMI_ENV=development bundle exec hanami db migrate'"
# alias an_prepare_test="anzeigen bash -c 'HANAMI_ENV=test bundle exec rake db:parallel_test:prepare'"
alias an_prepare_test="anzeigen bash -c 'HANAMI_ENV=test bundle exec hanami db prepare'"
alias an_prepare_dev="anzeigen bash -c 'HANAMI_ENV=development bundle exec hanami db prepare'"
alias aspec='anzeigen bundle exec rspec'
alias raspec='anzeigen bundle exec rescue rspec'

cspec() {
  if [ -n "$1" ]
  then
    clubhouse bash -c "HANAMI_ENV=test bundle exec rspec $*"
  else
    clubhouse bash -c "HANAMI_ENV=test parallel_rspec spec"
  fi
}

alias clubhouse_restart='bash -c "cd ~/work/studitemps-docker; docker compose restart clubhouse"'
alias clubhouse_config='vim ~/work/studitemps-docker/configs/clubhouse/env.env'
alias clubhouse_knapsack_report="clubhouse bash -c 'KNAPSACK_GENERATE_REPORT=true RACK_ENV=test bundle exec rspec spec'"

jobsearch() {
  docker exec -it jobsearch "$@"
}
alias jobserver="jobsearch bundle exec rails server -b '0.0.0.0' -p 5645 -e development"

doco() {
  bash -c "cd ~/work/studitemps-docker; docker compose $*"
}

foco() {
  bash -c "cd ~/work/studibase; docker compose $*"
}

soco() {
  bash -c "cd ~/work/studibase; docker compose $*"
}

alias ccat='highlight -O ansi'
alias bat='bat -p --paging auto'

start_work() {
    bash -c "cd ~/work/studitemps-docker; docker compose up -d"
    gnome-terminal -- docker exec -it jobmensa bash -c 'bundle install --jobs=20; bundle pack --all; bundle exec rails server -b 0.0.0.0 -p 80; bash'
    gnome-terminal -- docker exec -it clubhouse bash -c 'bundle install --jobs=20; bundle pack --all; bundle exec hanami server --host 0.0.0.0; bash'
    gnome-terminal -- bash -c 'cd ~/work/clubhouse; while true; do echo doing stuff; ripper-tags -R; echo did stuff, sleeping...; sleep 10; done'
}

alias jobmensa='docker exec -it jobmensa'
# alias jobmensa_server='jobmensa bundle exec puma -C config/puma.rb'
alias jobmensa_server='jobmensa bundle exec rails server -b 0.0.0.0 -p 80'
alias jobmensa_shell='jobmensa rails c'
alias jobmensa_rspec='jobmensa bundle exec rspec'
alias jspec='jobmensa_rspec'
alias jobmensa_bundle="jobmensa bash -c 'bundle install --jobs=20; bundle pack --all'"
# alias jobmensa_rspec='jobmensa sh -c "export RAILS_ENV=test ELASTICSEARCH_URL=localhost:9200; bundle exec rspec"'

jcumber() {
  jobmensa bash -c "RAILS_ENV=test bundle exec rake db:drop db:create db:structure:load"
  jobmensa bash -c "HOST_NAME=localhost TEST_PORT=80 RAILS_ENV=test cucumber $*"
}
# WORK END #

backup_fbase_staging() {
  BACKUP_NAME=$1
  time (fbase gcloud --project=studi-base-staging firestore export gs://studi-base-staging.appspot.com/"$BACKUP_NAME")
}

backup_fbase_prod() {
  BACKUP_NAME=$1
  time (fbase gcloud --project=studi-base firestore export gs://studi-base.appspot.com/"$BACKUP_NAME")
}

app_login() {
  bash -c "cd ~/work/studibase/app/functions/; npm run app_login $*"
}
# source ~/.config/zsh/app_login.sh
