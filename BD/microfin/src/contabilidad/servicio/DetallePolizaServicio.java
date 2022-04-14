package contabilidad.servicio;
import java.util.List;

import cliente.bean.ClienteBean;
import reporte.ParametrosReporte;
import reporte.Reporte;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import contabilidad.dao.DetallePolizaDAO;
import contabilidad.servicio.CuentasContablesServicio.Enum_Con_CuentasContables;
import contabilidad.bean.CePolizasBean;
import contabilidad.bean.CuentasContablesBean;
import contabilidad.bean.DetallePolizaBean;

public class DetallePolizaServicio  extends BaseServicio {
	private DetallePolizaServicio(){
		super();
	}

	DetallePolizaDAO detallePolizaDAO = null;

	public static interface Enum_Lis_DetallePoliza{
		int principal 		= 1;
		int plantilla 		= 2;
		int CePolizasXml	= 3;
		int auxiliarCuentas	= 4;
		int auxiliarFolios	= 5;
	}
	
	
	public static interface Enum_Con_DetallePoliza{
		int repMov 		= 1;
		
	}


	public List lista(int tipoLista, DetallePolizaBean detallePoliza){
		List detallePolizaLista = null;
		switch (tipoLista) {
	        case  Enum_Lis_DetallePoliza.principal:
	        	detallePolizaLista = detallePolizaDAO.lista(detallePoliza, tipoLista);
	        break;
	        case  Enum_Lis_DetallePoliza.plantilla:
        	detallePolizaLista = detallePolizaDAO.listaDetallePolPla(detallePoliza, tipoLista);
	        break;	        
		}
		return detallePolizaLista;
	}

	public List listaCePolizas(int tipoLista, CePolizasBean polizasBean){
		List detallePolizaLista = null;
		switch (tipoLista) {
	        case  Enum_Lis_DetallePoliza.CePolizasXml:
        	detallePolizaLista = detallePolizaDAO.listaCePolizasXml(polizasBean);
	        break;
	        case  Enum_Lis_DetallePoliza.auxiliarCuentas:
	        	detallePolizaLista = detallePolizaDAO.listaCeAuxiliarCuentasXml(polizasBean);
		    break;
	        case  Enum_Lis_DetallePoliza.auxiliarFolios:
	        	detallePolizaLista = detallePolizaDAO.listaCeAuxiliarFoliosXml(polizasBean);
		    break;
	        
		}
		return detallePolizaLista;
	}
	
	
	public void setDetallePolizaDAO(DetallePolizaDAO detallePolizaDAO) {
		this.detallePolizaDAO = detallePolizaDAO;
	}
	
}
