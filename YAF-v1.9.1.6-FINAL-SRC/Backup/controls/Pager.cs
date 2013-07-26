using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace yaf.controls
{
	/// <summary>
	/// Summary description for Pager.
	/// </summary>
	public class Pager : BaseControl, System.Web.UI.IPostBackEventHandler
	{
		private bool usePostBack = true;

		public Pager()
		{
			this.Load += new EventHandler( Pager_Load );
		}

		private void Pager_Load( object sender, EventArgs e )
		{
		}

		protected override void Render( HtmlTextWriter output )
		{
			if ( LinkedPager != null )
			{
				Pager linkedPager = ( Pager ) Parent.FindControl( LinkedPager );
				if ( linkedPager == null )
					throw new Exception( string.Format( "Failed to link pager to '{0}'.", LinkedPager ) );
				linkedPager.Render( output );
				return;
			}

			if ( PageCount < 2 ) return;

			output.WriteLine( "<span>" );
			output.WriteLine( "{0:N0} pages:", PageCount );

			if ( UsePostBack ) OutputPostback( output );
			else OutputLinked( output );

			output.WriteLine( "</span>" );
		}

		private void OutputPostback( HtmlTextWriter output )
		{
			int iStart = CurrentPageIndex - 6;
			int iEnd = CurrentPageIndex + 7;
			if ( iStart < 0 ) iStart = 0;
			if ( iEnd > PageCount ) iEnd = PageCount;

			if ( iStart > 0 )
				output.WriteLine( "<a href=\"{0}\">First</a> ...", Page.ClientScript.GetPostBackClientHyperlink( this, "0" ) );

			for ( int i = iStart; i < iEnd; i++ )
			{
				if ( i == CurrentPageIndex )
					output.WriteLine( "[{0}]", i + 1 );
				else
					output.WriteLine( "<a href=\"{0}\">{1}</a>", Page.ClientScript.GetPostBackClientHyperlink( this, i.ToString() ), i + 1 );
			}

			if ( iEnd < PageCount )
				output.WriteLine( "... <a href=\"{0}\">Last</a>", Page.ClientScript.GetPostBackClientHyperlink( this, ( PageCount - 1 ).ToString() ) );
		}

		private void OutputLinked( HtmlTextWriter output )
		{
			int iStart = CurrentPageIndex - 6;
			int iEnd = CurrentPageIndex + 7;
			if ( iStart < 0 ) iStart = 0;
			if ( iEnd > PageCount ) iEnd = PageCount;

			if ( iStart > 0 )
				output.WriteLine( "<a href=\"{0}\">First</a> ...", GetPageURL(0) );

			for ( int i = iStart; i < iEnd; i++ )
			{
				if ( i == CurrentPageIndex )
					output.WriteLine( "[{0}]", i + 1 );
				else
					output.WriteLine( "<a href=\"{0}\">{1}</a>", GetPageURL( i+1 ), i + 1 );
			}

			if ( iEnd < PageCount )
				output.WriteLine( "... <a href=\"{0}\">Last</a>", GetPageURL(PageCount) );
		}

		protected string GetPageURL(int page)
		{
			string url = "";

			// create proper query string...
			SimpleURLParameterParser parser = new SimpleURLParameterParser( System.Web.HttpContext.Current.Request.QueryString.ToString() );

			// get the current page
			Pages currentPage = (Pages) Enum.Parse(typeof(Pages),parser["g"],true);

			if ( parser ["m"] != null )
			{
				// must be converted to by topic...
				parser.Parameters.Remove( "m" );
				parser.Parameters.Add( "t", ForumPage.PageTopicID.ToString() );
			}

			if ( page > 1 )
			{
        string tmp = parser.CreateQueryString( new string [] { "g", "p", "tabid" } );
				if (tmp.Length > 0) tmp += "&";

				tmp += "p={0}";

				url = Forum.GetLink( currentPage, tmp, page );
			}
			else
			{
        url = Forum.GetLink( currentPage, parser.CreateQueryString( new string [] { "g", "p", "tabid" } ) );
			}

			return url;
		}

		public bool UsePostBack
		{
			get
			{
				return usePostBack;
			}
			set
			{
				usePostBack = value;
			}
		}

		public int Count
		{
			get
			{
				if ( ViewState ["Count"] != null )
					return ( int ) ViewState ["Count"];
				else
					return 0;
			}
			set
			{
				ViewState ["Count"] = value;
			}
		}

		public int CurrentPageIndex
		{
			get
			{
				if ( ViewState ["CurrentPageIndex"] != null )
					return ( int ) ViewState ["CurrentPageIndex"];
				else
					return 0;
			}
			set
			{
				ViewState ["CurrentPageIndex"] = value;
			}
		}

		public int PageSize
		{
			get
			{
				if ( ViewState ["PageSize"] != null )
					return ( int ) ViewState ["PageSize"];
				else
					return 20;
			}
			set
			{
				ViewState ["PageSize"] = value;
			}
		}

		public int PageCount
		{
			get
			{
				return ( int ) Math.Ceiling( ( double ) Count / PageSize );
			}
		}

		public string LinkedPager
		{
			get
			{
				return ( string ) ViewState ["LinkedPager"];
			}
			set
			{
				ViewState ["LinkedPager"] = value;
			}
		}

		#region IPostBackEventHandler
		public event EventHandler PageChange;

		public void RaisePostBackEvent( string eventArgument )
		{
			if ( PageChange != null )
			{
				CurrentPageIndex = int.Parse( eventArgument );
				PageChange( this, new EventArgs() );
			}
		}
		#endregion
	}
}
