package contabilidad.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;

import cliente.bean.MotivActivacionBean;
import cliente.servicio.MotivActivacionServicio.Enum_Lis_Motivos;
import contabilidad.bean.CatIngresosEgresosBean;
import contabilidad.dao.CatIngresosEgresosDAO;
import credito.servicio.ProductosCreditoServicio.Enum_Lis_ProductosCredito;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import reporte.ParametrosReporte;
import reporte.Reporte;


public class CatIngresosEgresosServicio extends BaseServicio {
	
	CatIngresosEgresosDAO	catIngresosEgresosDAO;
	
	public static interface Enum_Tra_CatTipoLista {
		int	alta			= 1;
		int	modificacion	= 2;
	}
	
	public static interface Enum_Con_CatTipoLista {
		int	principal	= 1;
	}
	
	public static interface Enum_Lis_CatTipoLista {
		int	principal	= 1;
		int listaCombo	= 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CatIngresosEgresosBean catIngresosEgresosBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_CatTipoLista.alta:
				
				if(catIngresosEgresosBean.getTipo().equals("E")){
					mensaje = catIngresosEgresosDAO.altaCatEgresos(catIngresosEgresosBean);
				}
				else
				{
					mensaje = catIngresosEgresosDAO.altaCatIngresos(catIngresosEgresosBean);
				}
				
				
				
				break;
			case Enum_Tra_CatTipoLista.modificacion:
				
				if(catIngresosEgresosBean.getTipo().equals("E")){
					mensaje = catIngresosEgresosDAO.modificaCatEgresos(catIngresosEgresosBean);
				}
				else
				{
					mensaje = catIngresosEgresosDAO.modificaCatIngresos(catIngresosEgresosBean);
				}
				
				break;
		}
		return mensaje;
	}
	public CatIngresosEgresosBean consulta(int tipoConsulta, CatIngresosEgresosBean catIngresosEgresosBean) {
		CatIngresosEgresosBean catIngresoEgreso = null;
		switch (tipoConsulta) {
			case Enum_Con_CatTipoLista.principal:
				
				if(catIngresosEgresosBean.getTipo().equals("E")){
					catIngresoEgreso = catIngresosEgresosDAO.consultaPrincipalEgresos(catIngresosEgresosBean, tipoConsulta);
				}
				else
				{
					catIngresoEgreso = catIngresosEgresosDAO.consultaPrincipalIngresos(catIngresosEgresosBean, tipoConsulta);
				}
				
				break;
		}
		return catIngresoEgreso;
	}
	
	public List<CatIngresosEgresosBean> lista(int tipoLista, CatIngresosEgresosBean catIngresosEgresosBean) {
		List<CatIngresosEgresosBean> lista = null;
		switch (tipoLista) {
			case Enum_Lis_CatTipoLista.principal:
				if(catIngresosEgresosBean.getTipo().equals("E")){
					lista = catIngresosEgresosDAO.listaEgresos(catIngresosEgresosBean, tipoLista);
				}
				else
				{
					lista = catIngresosEgresosDAO.listaIngresos(catIngresosEgresosBean, tipoLista);
				}
				
				
				break;
		}
		return lista;
	}

	
	public  Object[] listaCombo(CatIngresosEgresosBean catIngresosEgresosBean, int tipoLista) {
		List listaConceptos = null;
		switch(tipoLista){			
		case Enum_Lis_CatTipoLista.listaCombo: 
			
			if(catIngresosEgresosBean.getTipo().equals("E")){
				listaConceptos = catIngresosEgresosDAO.listaEgresos(tipoLista);
			}
			else
			{
				listaConceptos = catIngresosEgresosDAO.listaIngresos(tipoLista);
			}
			
			break;
			
			
		}
		return listaConceptos.toArray();		
	}
	
	
	

	public CatIngresosEgresosDAO getCatIngresosEgresosDAO() {
		return catIngresosEgresosDAO;
	}

	public void setCatIngresosEgresosDAO(CatIngresosEgresosDAO catIngresosEgresosDAO) {
		this.catIngresosEgresosDAO = catIngresosEgresosDAO;
	}

	
	
}
