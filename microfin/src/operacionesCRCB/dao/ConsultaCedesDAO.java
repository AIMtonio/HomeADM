package operacionesCRCB.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;



import operacionesCRCB.bean.ConsultaCedesBean;
import operacionesCRCB.beanWS.request.ConsultaAmortizacionCedeRequest;
import operacionesCRCB.beanWS.request.ConsultaCedesRequest;
import operacionesCRCB.beanWS.response.ConsultaAmortizacionCedeResponse;
import operacionesCRCB.beanWS.response.ConsultaCedesResponse;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ConsultaCedesDAO extends BaseDAO{

	ParametrosSesionBean 		parametrosSesionBean;

	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public ConsultaCedesDAO() {
		// TODO Auto-generated constructor stub
		super();
	}

	// consulta amortizacion de las Cedes
	public List listaAmortiCedes(ConsultaAmortizacionCedeRequest consultaAmortizacionesRequest , int tipoLista) {
		List listaAmortizacion = null;
		try{
			String query = "call CRCBCEDESWSCON(?,?,	?,?,?,?,?,?,?);";
			Object[] parametros = {	consultaAmortizacionesRequest.getCedeID(),
									tipoLista,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ConsultaCedesDAO.listaAmortiCedes",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRCBCEDESWSCON(" + Arrays.toString(parametros) + ")");
			listaAmortizacion	= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsultaCedesBean amortizacion = new ConsultaCedesBean();


						amortizacion.setCEDEID(resultSet.getString("CedeID"));
						amortizacion.setAmortizacionID(resultSet.getString("AmortizacionID"));
						amortizacion.setFechaInicio(resultSet.getString("FechaInicio"));
						amortizacion.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
						amortizacion.setFechaPago(resultSet.getString("FechaPago"));
						amortizacion.setCapital(resultSet.getString("Capital"));
						amortizacion.setInteres(resultSet.getString("Interes"));
						amortizacion.setInteresRetener(resultSet.getString("InteresRetener"));
						amortizacion.setEstatus(resultSet.getString("Estatus"));

						return amortizacion;

				}

			});
		}catch(Exception e){
			e.printStackTrace();
		}

		return listaAmortizacion;
	}


	public ConsultaCedesResponse consultaCedes(final ConsultaCedesRequest requestBean, final int tipoConsulta) {
		ConsultaCedesResponse responseCon = null;

		try{
			String query = "call CRCBCEDESWSCON(?,?,	?,?,?,?,?,?,?);";
			Object[] parametros = {
									requestBean.getCedeID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ConsultaCedesDAO.consultaCedes",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRCBCEDESWSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ConsultaCedesResponse cedeBean = new ConsultaCedesResponse();

					cedeBean.setCEDEID(resultSet.getString("CedeID"));
					cedeBean.setCapital(resultSet.getString("Monto"));
					cedeBean.setFechaInicio(resultSet.getString("FechaInicio"));
					cedeBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					cedeBean.setFechaPago(resultSet.getString("FechaPago"));
					cedeBean.setInteres(resultSet.getString("InteresGenerado"));
					cedeBean.setInteresRetener(resultSet.getString("InteresRetener"));
					cedeBean.setTasa(resultSet.getString("TasaFija"));
					cedeBean.setTasaISR(resultSet.getString("TasaISR"));
					cedeBean.setGATReal(resultSet.getString("ValorGatReal"));
					cedeBean.setPlazo(resultSet.getString("Plazo"));
					cedeBean.setEstatus(resultSet.getString("Estatus"));
					cedeBean.setCodigoRespuesta((resultSet.getString("NumErr")));

					return cedeBean;

				}
			});
			responseCon= matches.size() > 0 ? (ConsultaCedesResponse) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de cede  WS ", e);
		}
		return responseCon;
	}


	public ConsultaAmortizacionCedeResponse validaConsultaAmortizaciones(final ConsultaAmortizacionCedeRequest consultaAmortizacionesBean, final int tipoLista) {
		ConsultaAmortizacionCedeResponse mensaje = null;

		mensaje = (ConsultaAmortizacionCedeResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				ConsultaAmortizacionCedeResponse mensajeBean = null;
				try {
					// Query con el Store Procedure
					mensajeBean = (ConsultaAmortizacionCedeResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CRCBCEDESCONWSVAL(" +
										"?,?,	?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CedeID",Utileria.convierteLong(consultaAmortizacionesBean.getCedeID()));
									sentenciaStore.setInt("Par_NumValida", tipoLista);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									ConsultaAmortizacionCedeResponse mensajeTransaccion = new ConsultaAmortizacionCedeResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("NumErr"));
										mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setCodigoRespuesta("999");
										mensajeTransaccion.setMensajeRespuesta(Constantes.MSG_ERROR + " .ConsultaCedesDAO");

									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new ConsultaAmortizacionCedeResponse();
							mensajeBean.setCodigoRespuesta("999");
							throw new Exception(Constantes.MSG_ERROR + " .ConsultaCedesDAO");
						}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
								throw new Exception(mensajeBean.getMensajeRespuesta());
						}
					} catch (Exception e) {

						if(mensajeBean ==  null){
							mensajeBean = new ConsultaAmortizacionCedeResponse();
							mensajeBean.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
									+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-CONSULTAAMORTIZACIONCEDES");
						}

						if(Utileria.convierteEntero(mensajeBean.getCodigoRespuesta()) == 0){
							mensajeBean.setCodigoRespuesta("999");
						}

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en WS de Validación de Consulta de Amortizaciones de CEDES:" + e);
						e.printStackTrace();
						transaction.setRollbackOnly();

					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


		public ConsultaCedesResponse validaConsultaCede(final ConsultaCedesRequest consultaBean, final int tipoLista) {
			ConsultaCedesResponse mensaje = null;

			mensaje = (ConsultaCedesResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				ConsultaCedesResponse mensajeBean = null;
				try {
					// Query con el Store Procedure
					mensajeBean = (ConsultaCedesResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CRCBCEDESCONWSVAL(" +
										"?,?,	?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CedeID",Utileria.convierteLong(consultaBean.getCedeID()));
									sentenciaStore.setInt("Par_NumValida", tipoLista);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									ConsultaCedesResponse mensajeTransaccion = new ConsultaCedesResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("NumErr"));
										mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setCodigoRespuesta("999");
										mensajeTransaccion.setMensajeRespuesta(Constantes.MSG_ERROR + " .ConsultaCedesDAO");

									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new ConsultaCedesResponse();
							mensajeBean.setCodigoRespuesta("999");
							throw new Exception(Constantes.MSG_ERROR + " .ConsultaCedesDAO");
						}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
								throw new Exception(mensajeBean.getMensajeRespuesta());
						}
					} catch (Exception e) {

						if(mensajeBean ==  null){
							mensajeBean = new ConsultaCedesResponse();
							mensajeBean.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
									+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-CONSULTACEDES");
						}

						if(Utileria.convierteEntero(mensajeBean.getCodigoRespuesta()) == 0){
							mensajeBean.setCodigoRespuesta("999");
						}

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en WS de Validación de Consulta de CEDES:" + e);
						e.printStackTrace();
						transaction.setRollbackOnly();

					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		public ParametrosSesionBean getParametrosSesionBean() {
			return parametrosSesionBean;
		}

		public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
			this.parametrosSesionBean = parametrosSesionBean;
		}


}
