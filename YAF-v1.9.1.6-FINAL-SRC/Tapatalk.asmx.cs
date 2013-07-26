using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using CookComputing.XmlRpc;

namespace yaf
{
    /// <summary>
    /// Summary description for Tapatalk
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    public class Tapatalk : XmlRpcService
    {

        [XmlRpcMethod("Hello World",
        Description = "Return Hello World")] 
        public string HelloWorld()
        {
            return "Hello World";
        }
    }
}
