package tarjetas.servicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import tarjetas.bean.LineaTarjetaCreditoBean;
import tarjetas.dao.LineaTarjetaCreditoDAO;


public class LineaTarjetaCreditoServicio extends BaseServicio {

	private LineaTarjetaCreditoServicio(){
		super();
	}

	LineaTarjetaCreditoDAO lineaTarjetaCreditoDAO = null;
	

	public static interface Enum_Lis_LineaCredito{
		int lineaCteTodas		= 1;
		int numCte				= 2;
		int ctaCte				= 3;
	}

	public static interface Enum_Con_LineaCredito{
		int conLineaCredito 		= 1;
		int conUltimoCorte			= 2;
	}
	
	public List lista(int tipoLista, LineaTarjetaCreditoBean lineaTarjetaCreditoBean){
		List lineaTarjetaLista = null;
		switch (tipoLista) {
	        case  Enum_Lis_LineaCredito.lineaCteTodas:
	        	lineaTarjetaLista = lineaTarjetaCreditoDAO.listaLineasCliTodas(lineaTarjetaCreditoBean, tipoLista);
	        break;
	        case  Enum_Lis_LineaCredito.numCte:
	        	lineaTarjetaLista = lineaTarjetaCreditoDAO.listaLineasCliTodas(lineaTarjetaCreditoBean, tipoLista);
	        break;
	        case  Enum_Lis_LineaCredito.ctaCte:
	        	lineaTarjetaLista = lineaTarjetaCreditoDAO.listaCtasCliente(lineaTarjetaCreditoBean, tipoLista);
	        break;
  
		}
		return lineaTarjetaLista;
		
	}

	

	public LineaTarjetaCreditoBean consulta(int tipoConsulta, LineaTarjetaCreditoBean lineaTarjetaCreditoBean){
		LineaTarjetaCreditoBean lineaCredito = null;
		switch(tipoConsulta){
			case Enum_Con_LineaCredito.conUltimoCorte:
				lineaCredito = lineaTarjetaCreditoDAO.consultaCorte(tipoConsulta, lineaTarjetaCreditoBean);
			break;
			case Enum_Con_LineaCredito.conLineaCredito:
				lineaCredito = lineaTarjetaCreditoDAO.consultaLineaTarjetaCte(tipoConsulta, lineaTarjetaCreditoBean);
			break;
			
			}
		return lineaCredito;
	}

	
	
	
	public LineaTarjetaCreditoDAO getLineaTarjetaCreditoDAO() {
		return lineaTarjetaCreditoDAO;
	}
	public void setLineaTarjetaCreditoDAO(
			LineaTarjetaCreditoDAO lineaTarjetaCreditoDAO) {
		this.lineaTarjetaCreditoDAO = lineaTarjetaCreditoDAO;
	}
	
	
	
	
}
