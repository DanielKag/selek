echo " _          _                       _      _    "
echo "| |        | |                     | |    | |   "
echo "| | ___   _| |__   ___     ___  ___| | ___| | __"
echo "| |/ / | | | '_ \\ / _ \\   / __|/ _ \\ |/ _ \\ |/ /"
echo "|   <| |_| | |_) |  __/   \\__ \\  __/ |  __/   < "
echo "|_|\\_\\\\__,_|_.__/ \___|   |___/\\___|_|\\___|_|\\_\\"


dc=$(echo '42\n84\n96\n208\nae1\nuw2-pub-1\nuw2-edt-1' | fzf --sync --height 10 --header "Select DC:")

if [ -z "$dc" ]; then
  echo "No DC selected"
  return 
fi

kubectl config use-context $dc

namespace=$(echo 'tb-viewer\nsite-assets\nviewer-server' | fzf --sync --height 10 --header "Select namespace:")
if [ -z "$namespace" ]; then
  echo "No namespace selected"
  return 
fi

# describe_cmd="kubectl describe pod -n $namespace {1}"
describe_cmd="echo '{1}"

pod_name=$(kubectl get pods -n $namespace \
             | fzf --header-lines 1 \
                --ansi --exact \
                --header $'↑/↓ - Select\n<Enter> - ssh to the pod\n<Esc> - Cancel' \
                --preview "kubectl describe pod -n $namespace {1}" \
                    | cut -d\  -f 1)

if [ -n "$pod_name" ]; then
  kubectl exec -it -n tb-viewer $pod_name -- bash
fi


