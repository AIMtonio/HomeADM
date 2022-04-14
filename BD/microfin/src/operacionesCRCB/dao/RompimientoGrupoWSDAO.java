package operacionesCRCB.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;

import operacionesCRCB.bean.RG_ClienteBean;
import operacionesCRCB.bean.RG_CreditoBean;
import operacionesCRCB.bean.RG_ListaClienteBean;
import operacionesCRCB.bean.RG_ListaCreditoBean;
import operacionesCRCB.beanWS.request.RompimientoGrupoRequest;
import operacionesCRCB.beanWS.response.RompimientoGrupoResponse;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import credito.bean.CreditosBean;
import credito.bean.RompimientoGrupoBean;
import credito.servicio.CreditosServicio;
import credito.servicio.RompimientoGrupoServicio;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RompimientoGrupoWSDAO extends BaseDAO {


	ParametrosSesionBean parametrosSesionBean = null;
	CreditosServicio creditosServicio = null; 
	RompimientoGrupoServicio rompimientoGrupoServicio = null; 
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public RompimientoGrupoWSDAO() {
		super();
	}

	public RompimientoGrupoResponse procesoRompimientoGrupo(final RompimientoGrupoRequest rompimientoGrupoRequest){
		
		RompimientoGrupoResponse rompimientoGrupoResponse = new RompimientoGrupoResponse();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		try {
			
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Objetos de Inicio
						CreditosBean creditosBean = null;
						CreditosBean consultaBean = null;
						RompimientoGrupoBean rompimientoGrupo = null;
						
						// int contador = 0;
						int tamanio = 0;
						String montoDeuda = "";
						
						// Obtengo la lista de credito y clientes
						RG_ListaCreditoBean listaCreditos = rompimientoGrupoRequest.getCreditoID();
						RG_ListaClienteBean listaClientes = rompimientoGrupoRequest.getClienteID();
						
						if(listaCreditos.getCreditoID().size() != listaClientes.getClienteID().size()){
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("El Número de Creditos y de Clientes no es el mismo por tal motivo la operació no puede completarse");
							throw new Exception(mensajeBean.getDescripcion());
						}
						
						rompimientoGrupo = new RompimientoGrupoBean();
						rompimientoGrupo.setCicloActual(rompimientoGrupoRequest.getNumCiclo());
						rompimientoGrupo.setGrupoID(rompimientoGrupoRequest.getGrupoID());
						
						rompimientoGrupo = rompimientoGrupoServicio.consulta(RompimientoGrupoServicio.Enum_Con_RompimientoGrupo.funcionExibileGrupal, rompimientoGrupo);
						if (rompimientoGrupo == null ) {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("Ha ocurrido un Error al calcular el Exigible Grupal.");
							throw new Exception(mensajeBean.getDescripcion());
						}

						montoDeuda = rompimientoGrupo.getExigibleGrupal();
						
						tamanio = listaCreditos.getCreditoID().size();
						for (int iteracion = 0; iteracion < tamanio; iteracion++) {
							
							// consulto al credito para obtener su solicitud de crédito
							creditosBean = new CreditosBean();
							creditosBean.setCreditoID(listaCreditos.getCreditoID().get(iteracion));
							
							consultaBean = creditosServicio.consulta(CreditosServicio.Enum_Con_Creditos.principal, creditosBean);
							if (consultaBean == null) {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("El crédito consultado no Existe");
								throw new Exception(mensajeBean.getDescripcion());
							}
																					
							// Se realiza el rompimiento del grupo
							RompimientoGrupoBean rompimientoGrupoBean = new RompimientoGrupoBean();
							rompimientoGrupoBean.setCreditoID(listaCreditos.getCreditoID().get(iteracion));
							rompimientoGrupoBean.setClienteID(listaClientes.getClienteID().get(iteracion));
							
							rompimientoGrupoBean.setGrupoID(rompimientoGrupoRequest.getGrupoID());
							rompimientoGrupoBean.setCicloActual(rompimientoGrupoRequest.getNumCiclo());
							rompimientoGrupoBean.setSolicitudCreditoID(consultaBean.getSolicitudCreditoID());
							rompimientoGrupoBean.setUsuarioID(rompimientoGrupoRequest.getUsuario());
							rompimientoGrupoBean.setSucursalID(rompimientoGrupoRequest.getSucursal());
							rompimientoGrupoBean.setMotivo("ROMPIMIENTO MEDIANTE WEB SERVICE.");
							
							mensajeBean = rompimientoGrupoServicio.grabaTransaccion(RompimientoGrupoServicio.Enum_Transaccion.rompimientoWS, rompimientoGrupoBean);
						
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// Se realiza el alta de la bitacora
							rompimientoGrupoBean.setRompimientoID(mensajeBean.getConsecutivoInt());
							rompimientoGrupoBean.setExigibleGrupal(montoDeuda);
							
							mensajeBean = rompimientoGrupoServicio.grabaTransaccion(RompimientoGrupoServicio.Enum_Transaccion.bitacora, rompimientoGrupoBean);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Exclusion de Grupo Realizada Correctamente");

					}catch(Exception e){
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Ocurrió un error en el Rompimiento de Grupo ", e);
					}
					return mensajeBean;
				}
			});
			
			rompimientoGrupoResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
			rompimientoGrupoResponse.setMensajeRespuesta(mensaje.getDescripcion());

			
		}catch(Exception e){
			e.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
			}
			mensaje.setNumero(999);
			mensaje.setDescripcion("Ocurrió un error en el Rompimiento de Grupo");

			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Ocurrió un error en el Rompimiento de Grupo ", e);
		}

		return rompimientoGrupoResponse;
	}


	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public RompimientoGrupoServicio getRompimientoGrupoServicio() {
		return rompimientoGrupoServicio;
	}

	public void setRompimientoGrupoServicio(
			RompimientoGrupoServicio rompimientoGrupoServicio) {
		this.rompimientoGrupoServicio = rompimientoGrupoServicio;
	}
}
