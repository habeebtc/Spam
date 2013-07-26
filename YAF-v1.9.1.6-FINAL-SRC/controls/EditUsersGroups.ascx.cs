/* Yet Another Forum.net
 * Copyright (C) 2003 Bj�rnar Henden
 * http://www.yetanotherforum.net/
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace yaf.controls
{
    public partial class EditUsersGroups : BaseUserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindData();
            }
        }

        private void BindData()
        {
            UserGroups.DataSource = DB.group_member(ForumPage.PageBoardID, Request.QueryString["u"]);
            DataBind();
        }
        
        protected bool IsMember(object o)
        {
            return long.Parse(o.ToString()) > 0;
        }

        protected void Cancel_Click(object sender, System.EventArgs e)
        {
            Forum.Redirect(Pages.admin_users);
        }

        protected void Save_Click(object sender, System.EventArgs e)
        {
            for (int i = 0; i < UserGroups.Items.Count; i++)
            {
                RepeaterItem item = UserGroups.Items[i];
                int GroupID = int.Parse(((Label)item.FindControl("GroupID")).Text);
                DB.usergroup_save(Request.QueryString["u"], GroupID, ((CheckBox)item.FindControl("GroupMember")).Checked);
            }

            Forum.Redirect(Pages.admin_users);
        }

    }
}