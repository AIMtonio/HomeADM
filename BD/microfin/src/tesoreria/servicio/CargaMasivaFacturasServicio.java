package tesoreria.servicio;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import nomina.bean.CargaPagoErrorBean;
import nomina.servicio.BitacoraPagoNominaServicio.Enum_Lis_BitacoraPagos;
import tesoreria.bean.CargaMasivaFacturasBean;
import tesoreria.dao.CargaMasivaFacturasDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class CargaMasivaFacturasServicio extends BaseServicio{
	CargaMasivaFacturasDAO cargaMasivaFacturasDAO =null;

	public static interface Enum_Tra_CargaMasivaFact {
		int altaFacturasMasivas   		= 1;	//CARGA Y PROCESA EL ARCHIVO DE FACTRAS MASIVAS
		int procesaFacturasMasivas	 	= 2;	//PROCESA LA INFORMACION CARGARDA DE FACTURAS MASIVAS
		int altaProFacturasMasivas	 	= 3;	//ALTA DE PROVEEDORES
		int bajaFacturasMasivas	 		= 4;
	}
	
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_CargaMasivaFact{
		int lisExitosa		= 1;
		int lisFallida		= 2;
		int lisFolio		= 3;
	}
	
	// -------------- Tipo Lista Reporte----------------
		public static interface Enum_Lis_CargaMasivaFactRe{
			int lisProvExiste		= 1;
			int lisNoProvExiste		= 2;
		}
	
	public static interface Enum_Con_CargaMasivaFact{
		int folio			= 1;
		int detalleFolio	= 2;
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,CargaMasivaFacturasBean cargaMasivaFacturasBean, List<CargaMasivaFacturasBean> listaFactura) {
		MensajeTransaccionBean mensaje = null;

		switch (tipoTransaccion) {
			case Enum_Tra_CargaMasivaFact.altaFacturasMasivas:
			mensaje= cargaMasivaFacturasDAO.altaFacturasDetalle(cargaMasivaFacturasBean);
			break;
			case Enum_Tra_CargaMasivaFact.procesaFacturasMasivas:
				mensaje= cargaMasivaFacturasDAO.procesaFacturasDetalle(cargaMasivaFacturasBean, listaFactura);
			break;
			case Enum_Tra_CargaMasivaFact.altaProFacturasMasivas:
				mensaje= cargaMasivaFacturasDAO.altaProvFacturasMasivas(cargaMasivaFacturasBean);
			break;
			case Enum_Tra_CargaMasivaFact.bajaFacturasMasivas:
				mensaje= cargaMasivaFacturasDAO.bajaFacturasDetalle(cargaMasivaFacturasBean, listaFactura);
			break;
		}
		return mensaje;
	}
	
	public List lista(int tipoLista, CargaMasivaFacturasBean cargaMasivaFacturas){
		List cargaMasivaFacturasLis = null;
		switch (tipoLista) {
			case Enum_Lis_CargaMasivaFact.lisExitosa:
				cargaMasivaFacturasLis = cargaMasivaFacturasDAO.listaFacturaExitosas(tipoLista, cargaMasivaFacturas);
			break;
			case Enum_Lis_CargaMasivaFact.lisFallida:
				cargaMasivaFacturasLis = cargaMasivaFacturasDAO.listaFacturaFallidas(tipoLista, cargaMasivaFacturas);
			break;
			case Enum_Lis_CargaMasivaFact.lisFolio:
				cargaMasivaFacturasLis = cargaMasivaFacturasDAO.listaAyudaFolio(tipoLista, cargaMasivaFacturas);
			break;
		}
		return cargaMasivaFacturasLis;
	}
	
	public CargaMasivaFacturasBean consulta(int tipoConsulta, CargaMasivaFacturasBean cargaMasivaFacturas){
        CargaMasivaFacturasBean carga = null;
		switch (tipoConsulta) {
			case Enum_Con_CargaMasivaFact.folio:		
                carga = cargaMasivaFacturasDAO.consultaPrincipal(tipoConsulta, cargaMasivaFacturas); 
            break; 
			case Enum_Con_CargaMasivaFact.detalleFolio:		
                carga = cargaMasivaFacturasDAO.consultaDetalleFolio(tipoConsulta, cargaMasivaFacturas); 
            break; 
		} 
		
		return carga;
	}
	
	public List listaReporte(int tipoLista, CargaMasivaFacturasBean cargaMasivaFacturas){
		List cargaMasivaFacturasLis = null;
		switch (tipoLista) {
			case Enum_Lis_CargaMasivaFactRe.lisProvExiste:
				cargaMasivaFacturasLis = cargaMasivaFacturasDAO.listaProveedoresCargaMasiva(tipoLista, cargaMasivaFacturas);
			break;
		}
		return cargaMasivaFacturasLis;
	}
	
	public CargaMasivaFacturasDAO getCargaMasivaFacturasDAO() {
		return cargaMasivaFacturasDAO;
	}

	public void setCargaMasivaFacturasDAO(
			CargaMasivaFacturasDAO cargaMasivaFacturasDAO) {
		this.cargaMasivaFacturasDAO = cargaMasivaFacturasDAO;
	}
	
	
}
