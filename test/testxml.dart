import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

var xmlString = '''
<tr class='sortable'>
    <td class='ct-name' style='width:220px;padding:8px'>
        <i class='fa fa-arrows-v mover orange-text'></i>
        <span class='outer'>
            <span id='d837c0f8bd2a' onclick="addDockerContainerContext('ddns-go','0c9d07d74768','/boot/config/plugins/dockerMan/templates-user/my-ddns-go.xml',1,0,0,true,'','sh','d837c0f8bd2a','','','', '','')" class='hand'>
                <img src='/plugins/dynamix.docker.manager/images/question.png?1724345809' class='img' onerror=this.src='/plugins/dynamix.docker.manager/images/question.png' ;>
            </span>
            <span class='inner'>
                <span class='appname '>
                    <a class='exec' onclick="editContainer('ddns-go','/boot/config/plugins/dockerMan/templates-user/my-ddns-go.xml')">ddns-go</a>
                </span>
                <br>
                <i id='load-d837c0f8bd2a' class='fa fa-play started green-text'></i>
                <span class='state'>started</span>
            </span>
        </span>
        <div class='advanced' style='margin-top:8px'>
            Container ID: d837c0f8bd2a<br>By: jeessy/ddns-go
        </div>
    </td>
    <td class='updatecolumn'>
        <span class='green-text' style='white-space:nowrap;'>
            <i class='fa fa-check fa-fw'></i>
            up-to-date
        </span>
        <div class='advanced'>
            <a class='exec' onclick="updateContainer('ddns-go');">
                <span style='white-space:nowrap;'>
                    <i class='fa fa-cloud-download fa-fw'></i>
                    force update
                </span>
            </a>
        </div>
        <div class='advanced'>
            <i class='fa fa-info-circle fa-fw'></i>
            latest
        </div>
    </td>
    <td>host</td>
    <td style='white-space:nowrap'>
        <span class='docker_readmore'>
            192.168.124.4:9876/TCP<i class="fa fa-arrows-h" style="margin:0 6px"></i>
            192.168.124.4:9876
        </span>
    </td>
    <td style='word-break:break-all'>
        <span class='docker_readmore'></span>
    </td>
    <td class='advanced'>
        <span class='cpu-d837c0f8bd2a'>0%</span>
        <div class='usage-disk mm'>
            <span id='cpu-d837c0f8bd2a' style='width:0'></span>
            <span></span>
        </div>
        <br>
        <span class='mem-d837c0f8bd2a'>0 / 0</span>
    </td>
    <td>
        <input type='checkbox' id='d837c0f8bd2a-auto' class='autostart' container='ddns-go' checked>
        <span id='d837c0f8bd2a-wait' style='float:right;display:none'>
            wait<input class='wait' container='ddns-go' type='number' value='' placeholder='0' title="seconds">
        </span>
    </td>
    <td>
        <div style='white-space:nowrap'>
            Uptime: 2 minutes<div style='margin-top:4px'>Created: 3 minutes ago</div>
        </div>
    </td>
</tr>
<tr class='sortable'>
    <td class='ct-name' style='width:220px;padding:8px'>
        <i class='fa fa-arrows-v mover orange-text'></i>
        <span class='outer'>
            <span id='14d211f3b5c7' onclick="addDockerContainerContext('gateway-go','c552a1e0cc36','/boot/config/plugins/dockerMan/templates-user/my-gateway-go.xml',1,0,0,true,'','sh','14d211f3b5c7','','','', '','')" class='hand'>
                <img src='/plugins/dynamix.docker.manager/images/question.png?1724345809' class='img' onerror=this.src='/plugins/dynamix.docker.manager/images/question.png' ;>
            </span>
            <span class='inner'>
                <span class='appname '>
                    <a class='exec' onclick="editContainer('gateway-go','/boot/config/plugins/dockerMan/templates-user/my-gateway-go.xml')">gateway-go</a>
                </span>
                <br>
                <i id='load-14d211f3b5c7' class='fa fa-play started green-text'></i>
                <span class='state'>started</span>
            </span>
        </span>
        <div class='advanced' style='margin-top:8px'>
            Container ID: 14d211f3b5c7<br>By: openiothub/gateway-go
        </div>
    </td>
    <td class='updatecolumn'>
        <span class='green-text' style='white-space:nowrap;'>
            <i class='fa fa-check fa-fw'></i>
            up-to-date
        </span>
        <div class='advanced'>
            <a class='exec' onclick="updateContainer('gateway-go');">
                <span style='white-space:nowrap;'>
                    <i class='fa fa-cloud-download fa-fw'></i>
                    force update
                </span>
            </a>
        </div>
        <div class='advanced'>
            <i class='fa fa-info-circle fa-fw'></i>
            latest
        </div>
    </td>
    <td>host</td>
    <td style='white-space:nowrap'>
        <span class='docker_readmore'>
            192.168.124.4:34323/TCP<i class="fa fa-arrows-h" style="margin:0 6px"></i>
            192.168.124.4:34323<br>
            192.168.124.4:5353/UDP<i class="fa fa-arrows-h" style="margin:0 6px"></i>
            192.168.124.4:5353
        </span>
    </td>
    <td style='word-break:break-all'>
        <span class='docker_readmore'>
            /root<i class="fa fa-arrows-h" style="margin:0 6px"></i>
            /mnt/user/appdata/
        </span>
    </td>
    <td class='advanced'>
        <span class='cpu-14d211f3b5c7'>0%</span>
        <div class='usage-disk mm'>
            <span id='cpu-14d211f3b5c7' style='width:0'></span>
            <span></span>
        </div>
        <br>
        <span class='mem-14d211f3b5c7'>0 / 0</span>
    </td>
    <td>
        <input type='checkbox' id='14d211f3b5c7-auto' class='autostart' container='gateway-go' checked>
        <span id='14d211f3b5c7-wait' style='float:right;display:none'>
            wait<input class='wait' container='gateway-go' type='number' value='' placeholder='0' title="seconds">
        </span>
    </td>
    <td>
        <div style='white-space:nowrap'>
            Uptime: 13 hours<div style='margin-top:4px'>Created: 12 hours ago</div>
        </div>
    </td>
</tr>
 docker.push({name:'ddns-go',id:'d837c0f8bd2a',state:1,pause:0,update:0});docker.push({name:'gateway-go',id:'14d211f3b5c7',state:1,pause:0,update:0}); 0
''';

main() async {
    // 分割字符串到列表
    List<String> lines = xmlString.split('\n');

    // 移除最后一行
    if (lines.length > 1) {
        lines.removeLast();
        lines.removeLast();
    }

    // 重新组合字符串
    String result = lines.join('\n');
    print(result);
    // var result2 = '<html>'+result+'<\/html>';
    // print(result2);
    Document document = parser.parse(result, encoding: "utf-8");
    // 访问节点
    // var text = document.getElementsByTagName('html')[0].text;
    // var length = document.getElementsByTagName('tr').length;
    // print(length);
    var num = document.getElementsByClassName("hand").length;
    print(num);
    for (int i = 0; i< num; i++) {
        print(document.getElementsByClassName("state")[i].text);
        var text = document.getElementsByClassName("docker_readmore")[i *2].text.trim();
        // print("text:$text");
        RegExp regExp = RegExp(r'\d+.\d+.\d+.\d+:\d+/TCP'); // 使用非贪婪匹配来获取双引号内的内容
        Match? match = regExp.firstMatch(text);
        if (match != null) {
            var target = match.group(0)!; // group(1) 是捕获组的内容
            // print(csrf_token); // 输出: E5FDD8E7277F5CC6
            // print("target$target");
            var addr_port = target.split(RegExp("/")).first;
            String addr = addr_port.split(RegExp(":")).first;
            int port = int.parse(addr_port.split(RegExp(":")).last);
            print("addr port: ${addr}:${port}");
        }
        text = document.getElementsByClassName("hand")[i].id;
        print(text);
        text = document.getElementsByClassName("exec")[i *2].text;
        print(text);
    }
}
