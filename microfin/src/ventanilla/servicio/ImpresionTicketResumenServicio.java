package ventanilla.servicio;

import java.util.List;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;
import cedes.bean.CedesBean;
import cedes.servicio.CedesServicio;
import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;
import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;
import ventanilla.bean.ImpresionTicketResumenBean;
import ventanilla.dao.ImpresionTicketResumenDAO;

public class ImpresionTicketResumenServicio extends BaseServicio {

	AportacionesServicio aportacionesServicio = null;
	CedesServicio cedesServicio = null;
	ClienteServicio clienteServicio = null;
	CreditosServicio creditosServicio = null;
	CuentasAhoServicio cuentasAhoServicio = null;
	ImpresionTicketResumenDAO impresionTicketResumenDAO = null;
	InversionServicio inversionServicio = null;

	public static interface Enum_Consulta {
		int principal = 1;
	}

	public ImpresionTicketResumenBean consulta(int tipoConsulta, ImpresionTicketResumenBean impresionTicketResumenBean){

		ImpresionTicketResumenBean impresionTicketResumenBeanResponse = null;
		try{
			switch(tipoConsulta){
				case Enum_Consulta.principal:
					impresionTicketResumenBeanResponse = impresionTicketResumenDAO.consultaPrincipal(impresionTicketResumenBean, tipoConsulta);
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Impresión del Ticket Resumen en Ventanilla ", exception);
			exception.printStackTrace();
		}
		return impresionTicketResumenBeanResponse;
	}

	public ImpresionTicketResumenBean resumenCliente(ImpresionTicketResumenBean impresionTicketResumenBean){

		String clienteID = "";

		AportacionesBean aportacionesBean = null;
		CedesBean cedesBean = null;
		ClienteBean clienteBean = null;
		CreditosBean creditosBean = null;
		CuentasAhoBean cuentasAhoBean = null;
		ImpresionTicketResumenBean impresionTicketResumenBeanResponse = null;
		InversionBean inversionBean = null;
		MensajeTransaccionBean mensajeTransaccionBean = null;

		List<AportacionesBean> listaAportacionesBean = null;
		List<CedesBean> listaCedesBean = null;
		List<CreditosBean> listaCreditosBean = null;
		List<CuentasAhoBean> listaCuentasAhoBean = null;
		List<InversionBean> listaInversionBean = null;

		try{
			
			String mensaje = "";
			String safilocate = impresionTicketResumenBean.getSafilocale();
			mensajeTransaccionBean = new MensajeTransaccionBean();
			mensajeTransaccionBean.setNumero(999);
			
			if( impresionTicketResumenBean.getClienteID() == null ||
				Utileria.convierteEntero(impresionTicketResumenBean.getClienteID()) == Constantes.ENTERO_CERO ||
				impresionTicketResumenBean.getClienteID().equals(Constantes.STRING_VACIO) ){
				mensaje = "El Número del "+safilocate+" está Vacío.";
				mensajeTransaccionBean.setDescripcion(mensaje);
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			clienteID = impresionTicketResumenBean.getClienteID();

			aportacionesBean = new AportacionesBean();
			aportacionesBean.setClienteID(clienteID);

			cedesBean = new CedesBean();
			cedesBean.setClienteID(clienteID);

			creditosBean = new CreditosBean();
			creditosBean.setClienteID(clienteID);

			cuentasAhoBean = new CuentasAhoBean();
			cuentasAhoBean.setClienteID(clienteID);

			inversionBean = new InversionBean();
			inversionBean.setClienteID(clienteID);

			clienteBean = clienteServicio.consulta(ClienteServicio.Enum_Con_Cliente.principal, clienteID, Constantes.STRING_VACIO);
			if( clienteBean == null ){
				mensaje = "Error al obtener los datos del "+safilocate+".";
				mensajeTransaccionBean.setDescripcion(mensaje);
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			listaAportacionesBean = aportacionesServicio.lista(AportacionesServicio.Enum_Lis_Aportaciones.resumenCte, aportacionesBean);
			if( listaAportacionesBean == null ){
				mensaje = "Error al obtener el Resumen de las Aportaciones del "+safilocate+".";
				mensajeTransaccionBean.setDescripcion(mensaje);
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			listaCedesBean = cedesServicio.lista(CedesServicio.Enum_Lis_Cedes.resumenCte, cedesBean);
			if( listaCedesBean == null ){
				mensaje = "Error al obtener el Resumen de las Cedes del "+safilocate+".";
				mensajeTransaccionBean.setDescripcion(mensaje);
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			listaCreditosBean = creditosServicio.lista(CreditosServicio.Enum_Lis_Creditos.resumCteCredito, creditosBean);
			if( listaCreditosBean == null ){
				mensaje = "Error al obtener el Resumen de los Créditos del "+safilocate+".";
				mensajeTransaccionBean.setDescripcion(mensaje);
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			listaCuentasAhoBean = cuentasAhoServicio.lista(CuentasAhoServicio.Enum_Lis_CuentasAho.resumCte, cuentasAhoBean);
			if( listaCuentasAhoBean == null ){
				mensaje = "Error al obtener el Resumen de las Cuentas del "+safilocate+".";
				mensajeTransaccionBean.setDescripcion(mensaje);
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			listaInversionBean = inversionServicio.lista(InversionServicio.Enum_Lis_Inversion.resumCte, inversionBean);
			if( listaInversionBean == null ){
				mensaje = "Error al obtener el Resumen de las Inversiones del "+safilocate+".";
				mensajeTransaccionBean.setDescripcion(mensaje);
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			mensajeTransaccionBean.setDescripcion(Constantes.STR_CODIGOEXITO[1]);
			mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
			impresionTicketResumenBeanResponse = new ImpresionTicketResumenBean();
			impresionTicketResumenBeanResponse.setClienteID(impresionTicketResumenBean.getClienteID());
			impresionTicketResumenBeanResponse.setNombreCompleto(clienteBean.getNombreCompleto());
			impresionTicketResumenBeanResponse.setTransaccionID(impresionTicketResumenBean.getTransaccionID());
			impresionTicketResumenBeanResponse.setMensajeTransaccionBean(mensajeTransaccionBean);
			impresionTicketResumenBeanResponse.setListaAportacionesBean(listaAportacionesBean);
			impresionTicketResumenBeanResponse.setListaCedesBean(listaCedesBean);
			impresionTicketResumenBeanResponse.setListaCreditosBean(listaCreditosBean);
			impresionTicketResumenBeanResponse.setListaCuentasAhoBean(listaCuentasAhoBean);
			impresionTicketResumenBeanResponse.setListaInversionBean(listaInversionBean);

		} catch(Exception exception){

			loggerSAFI.error("Ha ocurrido un Error al obtener el Resumen en Ventanilla: ", exception);
			exception.printStackTrace();
			if (impresionTicketResumenBeanResponse == null) {
				impresionTicketResumenBeanResponse = new ImpresionTicketResumenBean();
			}

			impresionTicketResumenBeanResponse.setMensajeTransaccionBean(mensajeTransaccionBean);
		}
		return impresionTicketResumenBeanResponse;
	}

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}

	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}

	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
	}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	public ImpresionTicketResumenDAO getImpresionTicketResumenDAO() {
		return impresionTicketResumenDAO;
	}

	public void setImpresionTicketResumenDAO(
			ImpresionTicketResumenDAO impresionTicketResumenDAO) {
		this.impresionTicketResumenDAO = impresionTicketResumenDAO;
	}

	public InversionServicio getInversionServicio() {
		return inversionServicio;
	}

	public void setInversionServicio(InversionServicio inversionServicio) {
		this.inversionServicio = inversionServicio;
	}

}
