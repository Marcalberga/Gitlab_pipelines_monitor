import javax.net.ssl.*; 
import java.io.OutputStream; 
import java.net.HttpURLConnection; 
import java.net.URL; 
import java.security.cert.CertificateException; 
import java.security.cert.X509Certificate; 
import java.io.InputStreamReader; 
import processing.serial.*;

JSONArray values, projectsDataArray;
HttpURLConnection con;
String pipelinesData, projectsData;
Serial myPort;

// CUSTOM VALUES

// add your user private token from gitlab
String privateToken = "youPrivateToken";
// add the url for your gitlab instance, ie: http://gitlab.example.com
String gitlabUrl = "https://gitlab.example.com";
// add the refresh rate in seconds, how often will this sketch check for status
int refreshRate = 15;
// Sets need to verify certificate on https connections
boolean sslVerify = false;
// Sets connection to arduino
boolean arduino = true;
// Sets the COMM port to use when communication to arduino
int commElement = 2; // 2 on mac

// END CUSTOM VALUES

public void setup()
{
    trustAllHosts();
    String portName = Serial.list()[commElement];
    myPort = new Serial(this, portName, 9600);
    projectsDataArray = getProjectsData();
    int appHeight = getNumOfProjects(projectsDataArray) / 4;
    size(1000, 300);
    background(255);
    stroke(0); 
    fill(0);
}

public void draw()
{
    background(255);
    int x = 1000/8;
    int y = 150;
    int numOfPipelines = 0;
    int globalStatus = 0;
    for (int i = 0; i < projectsDataArray.size(); i++) {
      int projectId = projectsDataArray.getJSONObject(i).getInt("id");
      pipelinesData = getPipelineData(projectId);
      values = parseJSONArray(pipelinesData);
      if (values.size() > 0 ){
        String status = values.getJSONObject(0).getString("status");
        if(status.equals("success")) {
          fill(0, 255, 0);
        } else if (status.equals("running")) {
          globalStatus = 1;
          fill(0, 0, 255);
        } else {
          globalStatus = 2;
          fill(255, 0, 0); 
        }
        ellipse(x, y, 40, 40);
        fill(0);
        textAlign(CENTER);
        textSize(25);
        text(status, x, y + 50);
        textSize(35);
        text(projectsDataArray.getJSONObject(i).getString("name"), x, y - 50);
        x = x + (1000/4);
        if (numOfPipelines > 4 && numOfPipelines % 4 == 0) {
          println(i);
           x = 1000/8;
           y = y + 300;
           surface.setSize(1000, height + 300);
        }
        numOfPipelines++;
      }
    }
    if (arduino) {
      myPort.write(str(globalStatus));
    }
    
    delay(refreshRate * 100);
}

private int getNumOfProjects(JSONArray projectsData)
{
   return projectsData.size(); 
}

private String getPipelineData(int projectId)
{
  String datatemp = getGitlabGetData("/api/v4/projects/" + projectId + "/pipelines?per_page=1");
  return datatemp;
}

private JSONArray getProjectsData()
{
     projectsData = getGitlabGetData("/api/v4/projects?simple=true");
     return parseJSONArray(projectsData);
}

private String getGitlabGetData(String api_url)
{
  try {
    URL url = new URL(gitlabUrl + api_url);
    con = (HttpURLConnection) url.openConnection();
    con.setRequestProperty("PRIVATE-TOKEN", privateToken);
    con.setRequestMethod("GET");
    con.connect();
    StringBuffer text = new StringBuffer();
    InputStreamReader in = new InputStreamReader((InputStream) con.getContent());
    BufferedReader buff = new BufferedReader(in);
    String line;
    do {
      line = buff.readLine();
      if (line != null) {
        text.append(line);
      }
    } while (line != null);
    
    return (String) text.toString();
  } catch(IOException e) {
    println("error http");
    return "error";
  }
}

private void trustAllHosts() 
{
      if (!sslVerify) {
        TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                return new java.security.cert.X509Certificate[] {};
            }

            public void checkClientTrusted(X509Certificate[] chain,
                                           String authType) throws CertificateException
            {
            }

            public void checkServerTrusted(X509Certificate[] chain,
                                           String authType) throws CertificateException {
            }
        } };
        try {
            SSLContext sc = SSLContext.getInstance("SSL");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection
                    .setDefaultSSLSocketFactory(sc.getSocketFactory());
        } catch (Exception e) {
            e.printStackTrace();
        }
     }
}

static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "gitlab_test" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
}
