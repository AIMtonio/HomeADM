package cuentas.servicio;
import java.util.ArrayList;
import java.util.List;

import cuentas.bean.ComisionesSaldoPromedioBean;
import cuentas.dao.ComisionesSaldoPromedioDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.dao.UsuarioDAO;

public class ComisionesSaldoPromedioServicio extends BaseServicio{

	private ComisionesSaldoPromedioServicio(){
		super();
	}

	ComisionesSaldoPromedioDAO comisionesSaldoPromedioDAO = null;
	UsuarioDAO usuarioDAO = null;
	UsuarioBean usuario = new UsuarioBean();

	public static interface Enum_Tra_ComisionesPendientes{
		int condonacion 	= 1;
		int reversa 		= 2;
		
	}

	public static interface Enum_Con_ComisionesPendientes{
		int comisionesPendPago 	 = 1;
		int comisionesPagadas	 = 2;
	}
	
	public static interface Enum_Lis_ComisionesPendientes{
		int comPendienteCobro 	 	= 1;
		int comisionesPagadas 	 	= 2;
	}
	
	public static interface Enum_Lis_CatComisiones{
		int principal 	 		= 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoActualizacion,ComisionesSaldoPromedioBean comisiones) {
		MensajeTransaccionBean mensaje = null;

		switch (tipoActualizacion) {
			case Enum_Tra_ComisionesPendientes.condonacion:
				mensaje = validaProceso(comisiones, Enum_Tra_ComisionesPendientes.condonacion);
			break;
			case Enum_Tra_ComisionesPendientes.reversa:				
				mensaje = validaProceso(comisiones, Enum_Tra_ComisionesPendientes.reversa);
			break;
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean validaProceso(ComisionesSaldoPromedioBean comisiones, int tipoActualizacion) {
		MensajeTransaccionBean mensajeRes = new MensajeTransaccionBean();
		UsuarioBean usuarioCon = null;
		String contraseniaUser = SeguridadRecursosServicio.encriptaPass(comisiones.getUsuarioAutorizaID(), comisiones.getContraseniaUsuarioAutoriza());
		usuario.setUsuarioID(comisiones.getUsuarioID());
		usuario.setContrasenia(contraseniaUser);


		try {
			usuarioCon = usuarioDAO.consultaContraseniaUsuario(usuario, 6);

			if(usuarioCon.getContrasenia().equals(contraseniaUser)){
				ArrayList listaComSaldoProm = null;
				
				
				switch (tipoActualizacion) {
					case Enum_Tra_ComisionesPendientes.condonacion:
						listaComSaldoProm = (ArrayList) detatelleCondonacionComision(comisiones);
						mensajeRes = comisionesSaldoPromedioDAO.procesaInfCondoncaionSaldoProm(comisiones, listaComSaldoProm, Enum_Tra_ComisionesPendientes.condonacion);
						break;
					case Enum_Tra_ComisionesPendientes.reversa:	
						listaComSaldoProm = (ArrayList) detatelleReversaComision(comisiones);
						mensajeRes = comisionesSaldoPromedioDAO.procesaInfReversaSaldoProm(comisiones, listaComSaldoProm, Enum_Tra_ComisionesPendientes.reversa);
						break;
				}
			}else{
				mensajeRes.setNumero(001);
				mensajeRes.setNombreControl("contraseniaUsuarioAutoriza");
				mensajeRes.setDescripcion("El Usuario o Contraseña es Incorrecto.");
				throw new Exception(mensajeRes.getDescripcion());
			}
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en validacion de contraseña del usuario 'ComisionesSaldoPromedioServicio.procesaComisionesSaldoPromedio' " + e);
			e.printStackTrace();
			if (mensajeRes.getNumero() == 0) {
				mensajeRes.setNumero(999);
			}
		}
		return mensajeRes;
	}
	
	public ComisionesSaldoPromedioBean consulta(int tipoConsulta, ComisionesSaldoPromedioBean comisiones){
		ComisionesSaldoPromedioBean comisionesPendientes = null;
		switch(tipoConsulta){
			case Enum_Con_ComisionesPendientes.comisionesPendPago:
				comisionesPendientes = comisionesSaldoPromedioDAO.consultaComisionPendPago(comisiones, Enum_Con_ComisionesPendientes.comisionesPendPago);
			break;
			case Enum_Con_ComisionesPendientes.comisionesPagadas:
				comisionesPendientes = comisionesSaldoPromedioDAO.consultaComisionPagada(comisiones, Enum_Con_ComisionesPendientes.comisionesPagadas);
			break;

		}
		return comisionesPendientes;
	}
	
	public List lista(int tipoLista, ComisionesSaldoPromedioBean comisiones){
		List listaResult = null;
		
		switch (tipoLista){
			case Enum_Lis_ComisionesPendientes.comPendienteCobro:
				listaResult= comisionesSaldoPromedioDAO.listaComisionesPendientes(Enum_Lis_ComisionesPendientes.comPendienteCobro, comisiones);
			break;
			case Enum_Lis_ComisionesPendientes.comisionesPagadas:
				listaResult= comisionesSaldoPromedioDAO.listaComisionesCobradas(Enum_Lis_ComisionesPendientes.comisionesPagadas, comisiones);
			break;
		}
		return listaResult;
	}
	
	// TIPOS DE CONDONACIONES
	public List listaTipoCondonacion(int tipoLista, ComisionesSaldoPromedioBean comisiones){
		List listaResult = null;
		
		switch (tipoLista){
			case Enum_Lis_CatComisiones.principal:
				listaResult= comisionesSaldoPromedioDAO.listaComboTipoCondonacion(Enum_Lis_CatComisiones.principal, comisiones);
			break;
		}
		return listaResult;
	}
	
	// TIPOS DE REVERSA
	public List listaTipoReversa(int tipoLista, ComisionesSaldoPromedioBean comisiones){
		List listaResult = null;		
		switch (tipoLista){
			case Enum_Lis_CatComisiones.principal:
				listaResult= comisionesSaldoPromedioDAO.listaComboTipoReversa(Enum_Lis_CatComisiones.principal, comisiones);
			break;
		}
		return listaResult;
	}
	
	// DETALLE DE LISTA DE CONDONACION DE SALDO PROMEDIO
	public List detatelleCondonacionComision(ComisionesSaldoPromedioBean comisiones){
		List<String> listaComisionID  = comisiones.getLcomisionID();
		List<String> listaCuentaAhoID  = comisiones.getLcuentaAhoID();
		List<String> listaSaldoComision  = comisiones.getLsaldoComision();
		List<String> listaProceso  = comisiones.getLtipoProceso();
		List<String> listaMotivoProceso  = comisiones.getLmotivoProceso();
		List<String> listaSeleccionado  = comisiones.getLseleccionadoCheck();
	
		int tamanio=0;
		ComisionesSaldoPromedioBean comisionesSaldoPromedio = null;
		ArrayList listaDetalle = new ArrayList();
		
		if(listaComisionID!=null){
		  tamanio= listaComisionID.size();
		}
		
		for(int i = 0; i < tamanio; i++){
			comisionesSaldoPromedio = new ComisionesSaldoPromedioBean();
			if(listaSeleccionado.get(i).equals("S")){				
				comisionesSaldoPromedio.setClienteID(comisiones.getClienteID());
				comisionesSaldoPromedio.setUsuarioAutoriza(comisiones.getUsuarioID());
				
				comisionesSaldoPromedio.setComisionID(listaComisionID.get(i));
				comisionesSaldoPromedio.setCuentaAhoID(listaCuentaAhoID.get(i));
				comisionesSaldoPromedio.setSaldoComPendiente(listaSaldoComision.get(i));
				comisionesSaldoPromedio.setTipoCondonacion(listaProceso.get(i));
				comisionesSaldoPromedio.setMotivoProceso(listaMotivoProceso.get(i));

				listaDetalle.add(comisionesSaldoPromedio);
			}
			
		}
		
		return listaDetalle;
	}
	
	// DETALLE DE REVERSA DE COMISION SALDO PROMEDIO
	public List detatelleReversaComision(ComisionesSaldoPromedioBean comisiones){
		List<String> listaComisionID  = comisiones.getLcomisionID();
		List<String> listaCuentaAhoID  = comisiones.getLcuentaAhoID();
		List<String> listaSaldoComision  = comisiones.getLsaldoComision();
		List<String> listaIVAsaldoComision = comisiones.getlIVAsaldoComision();
		List<String> listaProceso  = comisiones.getLtipoProceso();
		List<String> listaMotivoProceso  = comisiones.getLmotivoProceso();
		List<String> listaSeleccionado  = comisiones.getLseleccionadoCheck();
		
		List<String> listaCobroID = comisiones.getLcobroID();
	
		int tamanio=0;
		ComisionesSaldoPromedioBean comisionesSaldoPromedio = null;
		ArrayList listaDetalle = new ArrayList();
		
		if(listaComisionID!=null){
		  tamanio= listaComisionID.size();
		}
		
		for(int i = 0; i < tamanio; i++){
			comisionesSaldoPromedio = new ComisionesSaldoPromedioBean();
			if(listaSeleccionado.get(i).equals("S")){				
				comisionesSaldoPromedio.setClienteID(comisiones.getClienteID());
				comisionesSaldoPromedio.setUsuarioAutoriza(comisiones.getUsuarioID());
				
				comisionesSaldoPromedio.setComisionID(listaComisionID.get(i));
				comisionesSaldoPromedio.setCuentaAhoID(listaCuentaAhoID.get(i));
				comisionesSaldoPromedio.setSaldoComPendiente(listaSaldoComision.get(i));
				comisionesSaldoPromedio.setIVAComisionPendiente(listaIVAsaldoComision.get(i));
				comisionesSaldoPromedio.setTipoReversa(listaProceso.get(i));
				comisionesSaldoPromedio.setMotivoProceso(listaMotivoProceso.get(i));
				comisionesSaldoPromedio.setCobroID(listaCobroID.get(i));

				listaDetalle.add(comisionesSaldoPromedio);
			}
			
		}
		
		return listaDetalle;
	}
	


	public ComisionesSaldoPromedioDAO getComisionesSaldoPromedioDAO() {
		return comisionesSaldoPromedioDAO;
	}

	public void setComisionesSaldoPromedioDAO(ComisionesSaldoPromedioDAO comisionesSaldoPromedioDAO) {
		this.comisionesSaldoPromedioDAO = comisionesSaldoPromedioDAO;
	}


	public UsuarioDAO getUsuarioDAO() {
		return usuarioDAO;
	}


	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}
	



}
