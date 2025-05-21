<%@ Page Language="C#" Debug="true" %>
<%@Import Namespace="System.Web"%>
<%@Import Namespace="System.Web.UI"%>
<%@Import Namespace="System.Security.Cryptography"%>
<script runat="server">


class RndStrGen
{
	public static String GenRndStr()
	{
		HttpRequest req = HttpContext.Current.Request;
		String strRet = "", strSeq = "", strTxtLength = "";
		int numTxtLength = 0, i = 0, cntType = 0;
		try
		{
			strTxtLength = req.Form["txtLength"];
			numTxtLength = Convert.ToInt32(strTxtLength);
		}
		catch (NullReferenceException e)
		{
		}
		if ( numTxtLength > 0 )
		{
			byte[] arrRnd = new byte[numTxtLength * 5];
			RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
			rng.GetBytes(arrRnd);
			int idxArr = 0;
			String [] chkTypes = req.Form.GetValues("chkType[]"), txtPwds = req.Form.GetValues("txtPwd[]");
			if (chkTypes!=null)
			{
				for(i = 0; i < chkTypes.Length; i++)
				{
					strRet = strRet + chkTypes[i];
				}
				for(i = chkTypes.Length; i < numTxtLength; i++)
				{
					strRet = strRet + chkTypes[arrRnd[idxArr] % chkTypes.Length];
					idxArr += 1;
				}
				for(i = 0; i < numTxtLength; i++)
				{
					ushort uNum2Pick = BitConverter.ToUInt16(arrRnd, idxArr);
					idxArr += 2;
					uNum2Pick %= Convert.ToUInt16(numTxtLength - i);
					strSeq = strSeq + strRet.Substring(uNum2Pick, 1);
					strRet = strRet.Remove(uNum2Pick, 1);
				}
				strRet = "";
				for(i = 0; i < numTxtLength; i++)
				{
					ushort uNum2Pick = BitConverter.ToUInt16(arrRnd, idxArr);
					idxArr += 2;
					int iType = Convert.ToInt32(strSeq.Substring(i,1));
					uNum2Pick %= Convert.ToUInt16(txtPwds[iType].Length);
					strRet = strRet + txtPwds[iType].Substring(uNum2Pick, 1);
				}
			}
		}
		return strRet;
	}
}

String strRnd = RndStrGen.GenRndStr();

</script>
<html>
<head>
</head>
<body>
	<center>
		<h3>Output Random String:</h3>
		<input type=text size=60 readonly value="<%= System.Web.HttpUtility.HtmlEncode(strRnd) %>">
	</center>
</body>
</html>