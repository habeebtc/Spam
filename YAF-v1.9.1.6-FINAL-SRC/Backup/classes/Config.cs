using System;
using System.Web;
using System.Reflection;
using yaf.pages;

namespace yaf
{
	public class Config
	{
		private System.Xml.XmlNode m_section;

		public Config( System.Xml.XmlNode node )
		{
			m_section = node;
		}

		public string this [string key]
		{
			get
			{
				System.Xml.XmlNode node = m_section.SelectSingleNode( key );
				if ( node != null )
					return node.InnerText;
				else
					return null;
			}
		}

		static private Config configSection
		{
			get
			{
				Config config = ( Config ) System.Configuration.ConfigurationManager.GetSection( "yafnet" );
				if ( config == null )
				{
					if ( System.Web.HttpContext.Current == null )
						throw new ApplicationException( "The main forum control is not design-time compatible due to it's complexity. Please load the individual page controls to modify the forum." );
					else
						throw new ApplicationException( "Failed to get configuration from Web.config." );
				}
				return config;
			}
		}

		static public Config yafSection
		{
			get
			{
				return configSection;
			}
		}

		static public string BoardID
		{
			get
			{
				return configSection[ "boardid" ];
			}
		}

		static public string CategoryID
		{
			get
			{
				return configSection[ "categoryid" ];
			}
		}

		static public string EnableURLRewriting
		{
			get
			{
				return configSection ["enableurlrewriting"];
			}
		}

		static public string UploadDir
		{
			get
			{
				return configSection[ "uploaddir" ];
			}
		}

		static public string Root
		{
			get
			{
				return configSection[ "root" ];
			}
		}

		static public string LogToMail
		{
			get
			{
				return configSection[ "logtomail" ];
			}
		}

		static public string ConnectionString
		{
			get
			{
				return configSection[ "connstr" ];
			}
		}

		static public bool IsDotNetNuke
		{
			get
			{
				object obj = HttpContext.Current.Items ["PortalSettings"];
				return obj != null && obj.GetType().ToString().ToLower().IndexOf( "dotnetnuke" ) >= 0;
			}
		}

		static public bool IsRainbow
		{
			get
			{
				object obj = HttpContext.Current.Items ["PortalSettings"];
				return obj != null && obj.GetType().ToString().ToLower().IndexOf( "rainbow" ) >= 0;
			}
		}

		static public bool IsPortal
		{
			get
			{
				return HttpContext.Current.Session ["YetAnotherPortal.net"] != null;
			}
		}

		static public bool IsCustom
		{
			get
			{
				return ( configSection ["CustomUserClass"] != null && configSection["CustomUserAssembly"] != null );
			}
		}

		static public IUrlBuilder UrlBuilder
		{
			get
			{
				if ( HttpContext.Current.Application ["yaf_UrlBuilder"] == null )
				{
					string urlAssembly;

					if ( IsRainbow )
					{
						urlAssembly = "yaf_rainbow.RainbowUrlBuilder,yaf_rainbow";
					}
					else if ( IsDotNetNuke )
					{
						urlAssembly = "yaf_dnn.DotNetNukeUrlBuilder,yaf_dnn";
					}
					else if ( IsPortal )
					{
						urlAssembly = "Portal.UrlBuilder,Portal";
					}
					else if ( EnableURLRewriting == "true" )
					{
						urlAssembly = "yaf.RewriteUrlBuilder,yaf";
					}
					else
					{
						urlAssembly = "yaf.UrlBuilder,yaf";
					}

					HttpContext.Current.Application ["yaf_UrlBuilder"] = Activator.CreateInstance( Type.GetType( urlAssembly ) );
				}

				return ( IUrlBuilder ) HttpContext.Current.Application ["yaf_UrlBuilder"];
			}
		}
	}
}
