package operacionesCRCB.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.InversionBean;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import operacionesCRCB.beanWS.request.AltaInversionRequest;
import operacionesCRCB.beanWS.response.AltaInversionResponse;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

public class AltaInversionesDAO extends BaseDAO{

	PolizaDAO					polizaDAO				= null;
	ParametrosSisServicio		parametrosSisServicio	= null;
	ParametrosSesionBean 		parametrosSesionBean;

protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public AltaInversionesDAO(){
		super();
	}

		//Alta Inversion Autorizada
		public AltaInversionResponse altaInversionWS( final AltaInversionRequest requestBean) {

			AltaInversionResponse mensajeInversion = new AltaInversionResponse();
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			ParametrosSisBean parametrosSisBean	= new ParametrosSisBean();

			final InversionBean inversionBean = new InversionBean();
			final PolizaBean polizaBean=new PolizaBean();
			final Long transaccion = parametrosAuditoriaBean.getNumeroTransaccion();
			int tipoConsulta = 7;

			parametrosSisBean = parametrosSisServicio.consulta(tipoConsulta, parametrosSisBean);

			// convertimos la fecha
			DateFormat fechaActual = new SimpleDateFormat("yyyy-MM-dd");
			String fechaConsulta = (parametrosSisBean.getFechaSistema().substring(0, 10));

			Date fechaSistema = null;
			try {

				fechaSistema = new Date (fechaActual.parse(fechaConsulta).getTime());

			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			parametrosSesionBean.setFechaSucursal(fechaSistema);

			polizaBean.setConceptoID(inversionBean.concApeInver);
			polizaBean.setConcepto(inversionBean.descApeInver);

			int	contador  = 0;
			while(contador <= PolizaBean.numIntentosGeneraPoliza){
				contador ++;
				polizaDAO.generaPolizaIDGenerico(polizaBean,transaccion);
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
					break;
				}
			}
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
				mensajeInversion = (AltaInversionResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						AltaInversionResponse mensajeAlta = new AltaInversionResponse();

						String poliza =polizaBean.getPolizaID();
						try {

							mensajeAlta= altaInversionAut(polizaBean, requestBean,transaccion);

							if((Integer.parseInt(mensajeAlta.getCodigoRespuesta()) != 0 )){
								throw new Exception(mensajeAlta.getMensajeRespuesta());
							}
						} catch (Exception e) {
							if(mensajeAlta.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
								mensajeAlta.setCodigoRespuesta("999");
							}
							mensajeAlta.setMensajeRespuesta(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de inversion autorizada", e);
						}
						return mensajeAlta;
					}
				});
				if(Integer.parseInt(mensajeInversion.getCodigoRespuesta())!=0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(polizaBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);

				}
			}else{
				mensajeInversion.setCodigoRespuesta("999");
				mensajeInversion.setMensajeRespuesta("El Número de Póliza se encuentra Vacio");
			}
			return mensajeInversion;
		}

		// aplicacion del pago
		public AltaInversionResponse altaInversionAut(final PolizaBean bean,final AltaInversionRequest requestBean, final Long transaccion) {
			AltaInversionResponse mensaje = new AltaInversionResponse();
				mensaje = (AltaInversionResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						AltaInversionResponse mensajeBean = new AltaInversionResponse();
						try{
							// Query con el Store Procedure
							mensajeBean = (AltaInversionResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call CRCBINVERSIONESWSPRO(" +
													"?,?,?,?,?, ?,?,	?,?,?,	?,?,?,?,?,?,?);";

										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(requestBean.getClienteID()));
										sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(requestBean.getCuentaAhoID()));
										sentenciaStore.setInt("Par_TipoInversionID", Utileria.convierteEntero(requestBean.getTipoInversionID()));
										sentenciaStore.setDouble("Par_Monto",  Utileria.convierteDoble(requestBean.getMonto()));
										sentenciaStore.setInt("Par_Plazo", Utileria.convierteEntero(requestBean.getPlazo()));

										sentenciaStore.setDouble("Par_Tasa",  Utileria.convierteDoble(requestBean.getTasa()));
										sentenciaStore.setLong("Par_Poliza",  Utileria.convierteLong(bean.getPolizaID()));

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",transaccion);

										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

										return sentenciaStore;
									}
								},new CallableStatementCallback() {
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																													DataAccessException {
										AltaInversionResponse mensajeTransaccion = new AltaInversionResponse();
										if(callableStatement.execute()){
											ResultSet resultadosStore = callableStatement.getResultSet();

											resultadosStore.next();

											mensajeTransaccion.setInversionID(resultadosStore.getString("InversionID"));
											mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("NumErr"));
											mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("ErrMen"));
											mensajeTransaccion.setMontoISR(resultadosStore.getString("ISRReal"));
											mensajeTransaccion.setInteresGenerado(resultadosStore.getString("InteresGenerado"));
											mensajeTransaccion.setInteresRecibir(resultadosStore.getString("InteresRecibir"));
											mensajeTransaccion.setMontoTotal(resultadosStore.getString("Monto"));
											mensajeTransaccion.setFechaVencimiento(resultadosStore.getString("FechaVencimiento"));


										}else{
											mensajeTransaccion.setCodigoRespuesta("999");
											mensajeTransaccion.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
										}

										return mensajeTransaccion;
									}
								}
								);

							if(mensajeBean ==  null){
								mensajeBean = new AltaInversionResponse();
								mensajeBean.setCodigoRespuesta("999");
								throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
								throw new Exception(mensajeBean.getMensajeRespuesta());
							}
						} catch (Exception e) {
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Inversion Autorizada WS", e);
							if (mensajeBean.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								mensajeBean.setCodigoRespuesta("999");
							}
							mensajeBean.setMensajeRespuesta(e.getMessage());
							transaction.setRollbackOnly();
						}
						return mensajeBean;
					}
			});
			return mensaje;
		}

		public PolizaDAO getPolizaDAO() {
			return polizaDAO;
		}

		public void setPolizaDAO(PolizaDAO polizaDAO) {
			this.polizaDAO = polizaDAO;
		}

		public ParametrosSisServicio getParametrosSisServicio() {
			return parametrosSisServicio;
		}

		public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
			this.parametrosSisServicio = parametrosSisServicio;
		}

		public ParametrosSesionBean getParametrosSesionBean() {
			return parametrosSesionBean;
		}

		public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
			this.parametrosSesionBean = parametrosSesionBean;
		}



}
