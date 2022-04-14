package credito.servicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import credito.bean.CreditosBean;
import credito.dao.CreditosDAO;
import credito.servicio.CreditosServicio.Enum_Con_Creditos;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ReporteCarteraCNBVServicio extends BaseServicio{	
	CreditosDAO creditosDAO=null;
 
	public ReporteCarteraCNBVServicio() {
		super();
	}
	//---------- Tipo de Consulta ----------------------------------------------------------------
	
	public static interface Enum_Lis_ReportesCNBV{
		int excel	 = 1;
		int csv 	 = 2;
	}	
	
	public static interface Enum_Con_Creditos {
		int principal	= 1;
		
	}
	
	
	
	public CreditosBean consulta(int tipoConsulta, CreditosBean creditosBean) {
		CreditosBean creditos = null;
		switch (tipoConsulta) {
			case Enum_Con_Creditos.principal :
				creditos = creditosDAO.consultaFinMes(creditosBean, tipoConsulta);
				break;
		}
		return creditos;
	}
	
	public List <CreditosBean>listaReportesCreditos(int tipoLista, CreditosBean creditosBean, HttpServletResponse response){
		List<CreditosBean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesCNBV.excel:
				listaReportes = creditosDAO.consultaCarteraCNBV(creditosBean, tipoLista);
				break;
			case Enum_Lis_ReportesCNBV.csv:
				listaReportes = generarReporteCarteraCNBV(creditosBean, Enum_Lis_ReportesCNBV.csv,  response);		
				break;		
		}
		return listaReportes;
	}
	
	
	private List generarReporteCarteraCNBV(CreditosBean repDIOTBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = creditosDAO.consultaCarteraCNBVCsv(repDIOTBean, tipoReporte);
		nombreArchivo="ReporteCarteraCNBV.csv";
		
		try{
			CreditosBean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (CreditosBean) listaBeans.get(i);
					writer.write(bean.getRenglon());        
					writer.write("\r\n");	
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		return listaBeans;
	}
	
	public String descripcionMes(String meses){
		String mes = "";
		int mese = Integer.parseInt(meses);
        switch (mese) {
            case 1:  mes ="ENERO" ; break;
            case 2:  mes ="FEBRERO"; break;
            case 3:  mes ="MARZO"; break;
            case 4:  mes ="ABRIL"; break;
            case 5:  mes ="MAYO"; break;
            case 6:  mes ="JUNIO"; break;
            case 7:  mes ="JULIO"; break;
            case 8:  mes ="AGOSTO"; break;
            case 9:  mes ="SEPTIEMBRE"; break;
            case 10: mes ="OCTUBRE"; break;
            case 11: mes ="NOVIEMBRE"; break;
            case 12: mes ="DICIEMBRE"; break;
        }
        return mes;
	}
	
	//------------getter y setter--------------

	public CreditosDAO getCreditosDAO() {
		return creditosDAO;
	}

	public void setCreditosDAO(CreditosDAO creditosDAO) {
		this.creditosDAO = creditosDAO;
	}

	
	

	
}
