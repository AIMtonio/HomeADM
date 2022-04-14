package tesoreria.servicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.List;

import cuentas.bean.CuentasAhoBean;
import soporte.bean.SucursalesBean;
import soporte.dao.SucursalesDAO;
import soporte.servicio.SucursalesServicio.Enum_Tra_Sucursal;
import tesoreria.bean.CuentaNostroBean;
import tesoreria.dao.CuentaNostroDAO;
import tesoreria.servicio.TesoMovsConciliaServicio.Enum_Con_CuentasAho;

 
public class CuentaNostroServicio extends BaseServicio { 
 
	CuentaNostroDAO cuentaNostroDAO = null;
	
	public static interface Enum_Tra_CuentaNostro {
		int alta = 1;
		int modificacion = 2;
		int elimina =3;
 
	}
	public static interface Enum_Con_CuentaNostro{
		int consultaSiExiste = 4;
		int conuslFolioInsti = 5;
		int consultaSaldo = 10;
		int consultaEstatus =11;
		int consultaUltFolio=12;
		int consultaRutaCheque = 13;
		int consultaFolioEmitido = 14;
		int consultaRutaChequeEstan = 16;
		int consultaChequeEmitido = 17;
	}
	public static interface Enum_Lis_CuentaNostro{
		int numCuentaInst = 3;
		int CtaChequeraInst = 5;
		int CtaInstFondeo =6;
		int CtaInstNostro =7;
		int listaTipoChequera = 15;
		
	}
	
	public static interface Enum_Act_CuentaNostro{
		int tipoActualizacion = 1;		
		
	}
	
	public CuentaNostroServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,CuentaNostroBean cuentaNostroBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) { 
			case Enum_Tra_CuentaNostro.alta:		
				mensaje = altaCuentaNostro(cuentaNostroBean);				
				break;				
			case Enum_Tra_CuentaNostro.modificacion:		
				mensaje = modificarCtaNostro(cuentaNostroBean);				
				break;				
			case Enum_Tra_CuentaNostro.elimina:		
				mensaje = eliminarCtaNostro(cuentaNostroBean);				
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaCuentaNostro(CuentaNostroBean cuentaNostroBean ){
		MensajeTransaccionBean mensaje = null;
	    mensaje = cuentaNostroDAO.altaCuentaNostro(cuentaNostroBean);
		return mensaje;
	}
	public MensajeTransaccionBean modificarCtaNostro(CuentaNostroBean cuentaNostroBean){
		MensajeTransaccionBean mensaje = null;
	    mensaje = cuentaNostroDAO.modificarCuentaNostro(cuentaNostroBean, Enum_Act_CuentaNostro.tipoActualizacion);
		return mensaje;
	}
	public MensajeTransaccionBean eliminarCtaNostro(CuentaNostroBean cuentaNostroBean ){
		MensajeTransaccionBean mensaje = null;
	    mensaje = cuentaNostroDAO.bajaCuentaNostro(cuentaNostroBean);
		return mensaje;
	}
	
	
	public CuentaNostroBean consultaExisteCta(int tipoConsulta, CuentaNostroBean  cuentaNostro){
		CuentaNostroBean  cuentaNtro = null;
		
		
		switch(tipoConsulta){
		   
				
		case Enum_Con_CuentaNostro.consultaSiExiste:		
				cuentaNtro = cuentaNostroDAO.consultaExisteCuenta(cuentaNostro, tipoConsulta);
				break;
				
		case Enum_Con_CuentaNostro.conuslFolioInsti:
			    cuentaNtro = cuentaNostroDAO.consultaFolioInstit(cuentaNostro, tipoConsulta);
			    break;
		case Enum_Con_CuentaNostro.consultaEstatus:
		    cuentaNtro = cuentaNostroDAO.consultaEstatusNumCtaInstitucio(cuentaNostro, tipoConsulta);
		    break;
		}
		return cuentaNtro;
	}
	
	public CuentaNostroBean consulta(int tipoConsulta, CuentaNostroBean cuentaNostroBean){
		CuentaNostroBean consultaCuentaNostro = null;
		switch(tipoConsulta){
		case Enum_Con_CuentaNostro.consultaSiExiste:		
			consultaCuentaNostro = cuentaNostroDAO.consultaExisteCuenta(cuentaNostroBean, tipoConsulta);
			break;
			case Enum_Con_CuentaNostro.consultaSaldo:
				consultaCuentaNostro = cuentaNostroDAO.consultaSaldo(cuentaNostroBean, tipoConsulta);
			break;
			case Enum_Con_CuentaNostro.consultaUltFolio:
					consultaCuentaNostro = cuentaNostroDAO.consultaUltimoFolio(cuentaNostroBean, tipoConsulta);
			break;
			case Enum_Con_CuentaNostro.consultaRutaCheque:
					consultaCuentaNostro = cuentaNostroDAO.consultaRutaCheque(cuentaNostroBean, tipoConsulta);
			break;
			case Enum_Con_CuentaNostro.consultaFolioEmitido:
					consultaCuentaNostro = cuentaNostroDAO.consultaFolioEmitido(cuentaNostroBean, tipoConsulta);
			break;		
			case Enum_Con_CuentaNostro.consultaRutaChequeEstan:
				consultaCuentaNostro = cuentaNostroDAO.consultaRutaChequeEstan(cuentaNostroBean, tipoConsulta);
				break;
			case Enum_Con_CuentaNostro.consultaChequeEmitido:
				consultaCuentaNostro = cuentaNostroDAO.consultaChequeEmitido(cuentaNostroBean, tipoConsulta);
				break;
				
		}
		return consultaCuentaNostro;
	}
	
	public List lista(int tipoLista, CuentaNostroBean cuentaNostroBean) {
		List cuentaNostroBn = null;

		switch (tipoLista) {
	        case  Enum_Lis_CuentaNostro.numCuentaInst:
	        	cuentaNostroBn = cuentaNostroDAO.listaNumCtaInstit(cuentaNostroBean, tipoLista);
	        break;
	        case  Enum_Lis_CuentaNostro.CtaChequeraInst:
	        	cuentaNostroBn = cuentaNostroDAO.listaNumCtaInstit(cuentaNostroBean, tipoLista);
	        break;	    
	        case  Enum_Lis_CuentaNostro.CtaInstFondeo:
	        	cuentaNostroBn = cuentaNostroDAO.listaNumCtaInstitFond(cuentaNostroBean, tipoLista);
	        break;
	        case  Enum_Lis_CuentaNostro.CtaInstNostro:
	        	cuentaNostroBn = cuentaNostroDAO.listaNumCtaInstitNostro(cuentaNostroBean, tipoLista);
	        break;
		}
		return cuentaNostroBn;
	}
	
	public  Object[] listaCombo(int tipoLista, CuentaNostroBean cuentaNostroBean){
		List cuentaNostro= null;

		switch (tipoLista) {
		case Enum_Lis_CuentaNostro.listaTipoChequera:
			cuentaNostro = cuentaNostroDAO.listaTipoChequera(cuentaNostroBean, tipoLista);
		break;
		}
		return cuentaNostro.toArray();
	}
	
	
	public CuentaNostroDAO getCuentaNostroDAO() {
		return cuentaNostroDAO;
	}
	public void setCuentaNostroDAO(CuentaNostroDAO cuentaNostroDAO) {
		this.cuentaNostroDAO = cuentaNostroDAO;
	}	
}//fin de la clase 
