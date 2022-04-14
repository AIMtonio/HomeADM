package tesoreria.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import tesoreria.bean.DispersionBean;
import tesoreria.bean.DispersionGridBean;
import tesoreria.bean.RenovacionOrdenPagoBean;
import tesoreria.servicio.OperDispersionServicio.Enum_Act_Dispersion;
import ventanilla.bean.ChequesEmitidosBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class RenovacionOrdenPagoDAO extends BaseDAO{
	private final static String salidaPantalla = "S";
	public String conceptoCancelacionOrden="839"; //tabla CONCEPTOSCONTA
	public String conceptoCancelacionOrdenDes="RENOVACION ORDEN PAGO DESEMBOLSO CREDITO"; //tabla CONCEPTOSCONTA
	String automatico = "A"; // indica que se trata de una poliza automatica
	PolizaDAO polizaDAO = new PolizaDAO();

	public RenovacionOrdenPagoDAO(){
		super();
	}

	public MensajeTransaccionBean ordenPagoAlta(final RenovacionOrdenPagoBean renovacionOrdenPagoBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ORDENPAGODESCREDALT(?,?,?,?,?, ?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(renovacionOrdenPagoBean.getClienteID()));
									sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(renovacionOrdenPagoBean.getInstitucionID()));
									sentenciaStore.setString("Par_NumCtaInstit",renovacionOrdenPagoBean.getNumCtaInstit());
									sentenciaStore.setString("Par_NumOrdenPago", renovacionOrdenPagoBean.getNumOrdenPago());
									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(renovacionOrdenPagoBean.getMonto()));
								    sentenciaStore.setString("Par_Beneficiario",renovacionOrdenPagoBean.getBeneficiario());
								    sentenciaStore.setString("Par_Referencia",renovacionOrdenPagoBean.getReferencia());
								    sentenciaStore.setString("Par_Concepto", renovacionOrdenPagoBean.getConcepto());
								    sentenciaStore.setString("Par_MotivoRenov",Constantes.STRING_VACIO);

								    //Parametros de OutPut
								    sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									MensajeTransaccionBean mensajeBloqueo = null;

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));


									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .RenovacionOrdenPagoDAO.ordenPagoAlta");
									}
									return mensajeTransaccion;
								}
							});

					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de orden de pago.", e);
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
	}


	public MensajeTransaccionBean renovacionOrdenPago(final RenovacionOrdenPagoBean renovacionOrdenPagoBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			transaccionDAO.generaNumeroTransaccion();
			final PolizaBean polizaBean = new PolizaBean();
			polizaBean.setConceptoID(conceptoCancelacionOrden);
			polizaBean.setConcepto(conceptoCancelacionOrdenDes);
			int	contador  = 0;
			// no se a dado de alta la poliza se agrega una poliza nueva

			while(contador <= PolizaBean.numIntentosGeneraPoliza){
				contador ++;
				polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
					break;
				}
			}

			if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String poliza = polizaBean.getPolizaID();
						try {
							renovacionOrdenPagoBean.setPolizaID(poliza);
							mensajeBean = renovacionOrdenPago(renovacionOrdenPagoBean, parametrosAuditoriaBean.getNumeroTransaccion());

							if(mensajeBean.getNumero() != 0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en renovación de orden de pago", e);
						}
						return mensajeBean;
					}
				});

				/* Baja de Poliza en caso de que haya ocurrido un error */
				if (mensaje.getNumero() != 0) {
					try {
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
						bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
						bajaPolizaBean.setDescProceso("RenovacionOrdenPagoDAO.renovacionOrdenPago");
						bajaPolizaBean.setPolizaID(renovacionOrdenPagoBean.getPolizaID());
						MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
						mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
						loggerSAFI.error(" Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				}
				/* Fin Baja de la Poliza Contable*/
			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}


		}catch(Exception ex){
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Realizar Renovación de Orden de Pago.");
			ex.printStackTrace();
		}
		return mensaje;
	}






	/*Renovacion de orden de pago para desebolso de credito por dispersion*/
	public MensajeTransaccionBean renovacionOrdenPago(final RenovacionOrdenPagoBean renovacionOrdenPagoBean,final long numeroTransaccion) {
		  MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call RENOVORDENPAGOPRO(?,?,?,?,?, ?,?,?,?,  ?,?,?, ?,?,?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_InstitucionIDCan", Utileria.convierteEntero(renovacionOrdenPagoBean.getInstitucionIDCan()));
										sentenciaStore.setString("Par_NumCtaInstitCan", renovacionOrdenPagoBean.getNumCtaInstitCan());
										sentenciaStore.setString("Par_NumOrdenPagoCan", renovacionOrdenPagoBean.getNumOrdenPagoCan());
										sentenciaStore.setString("Par_InstitucionID", renovacionOrdenPagoBean.getInstitucionID());
										sentenciaStore.setString("Par_NumCtaInstit", renovacionOrdenPagoBean.getNumCtaInstit());

										sentenciaStore.setString("Par_NumOrdenPago", renovacionOrdenPagoBean.getNumOrdenPago());
										sentenciaStore.setString("Par_Beneficiario", renovacionOrdenPagoBean.getBeneficiario());
										sentenciaStore.setString("Par_MotivoRenov", renovacionOrdenPagoBean.getMotivoRenov());
										sentenciaStore.setInt("Par_Poliza",Utileria.convierteEntero(renovacionOrdenPagoBean.getPolizaID()));

										sentenciaStore.setString("Par_Salida",salidaPantalla);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
										return sentenciaStore;
									}
								},new CallableStatementCallback() {
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																													DataAccessException {
										MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
										if(callableStatement.execute()){
											ResultSet resultadosStore = callableStatement.getResultSet();

											resultadosStore.next();
											mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
											mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
											mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));


										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .RenovacionOrdenPagoDAO.renovacionOrdenPago");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}

										return mensajeTransaccion;
									}
								}
								);

							if(mensajeBean ==  null){
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(999);
								throw new Exception(Constantes.MSG_ERROR + " .RenovacionOrdenPagoDAO.renovacionOrdenPago");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en renovación de orden de pago" + e);
							e.printStackTrace();
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
						}
						return mensajeBean;
					}
				});
				return mensaje;
	}

	public List listaOrdenesEmitidas(RenovacionOrdenPagoBean renovacionOrdenPagoBean, int tipoLista) {
		List listaOrdenesEmitidas = null;

		try{
			String query = "call ORDENPAGODESCREDLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					renovacionOrdenPagoBean.getInstitucionID(),
					renovacionOrdenPagoBean.getNumCtaInstit(),
					renovacionOrdenPagoBean.getNumOrdenPago(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"RenovacionOrdenPagoDAO.listaOrdenesEmitidas",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ORDENPAGODESCREDLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {

					RenovacionOrdenPagoBean renovacionOrdenPago = new RenovacionOrdenPagoBean();
					renovacionOrdenPago.setNumOrdenPago(resultSet.getString("NumOrdenPago"));
					renovacionOrdenPago.setBeneficiario(resultSet.getString("Beneficiario"));
					renovacionOrdenPago.setMonto(resultSet.getString("Monto"));
					renovacionOrdenPago.setFecha(resultSet.getString("Fecha"));

					return renovacionOrdenPago;
				}
			});
		listaOrdenesEmitidas= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Ordenes Emitidas", e);
		}
		return listaOrdenesEmitidas;
	}

	public RenovacionOrdenPagoBean consultaOrdenEmitidas(RenovacionOrdenPagoBean renovacionOrdenPagoBean, int tipoConsulta) {
		RenovacionOrdenPagoBean consultaOrdenesEmitidas= null;

		try{
			String query = "call ORDENPAGODESCREDCON(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(renovacionOrdenPagoBean.getInstitucionID()),
									renovacionOrdenPagoBean.getNumCtaInstit(),
									renovacionOrdenPagoBean.getNumOrdenPago(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"RenovacionOrdenPagoDAO.consultaOrdenEmitidas",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ORDENPAGODESCREDCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					RenovacionOrdenPagoBean renovacionOrdenPago = new RenovacionOrdenPagoBean();

					renovacionOrdenPago.setClienteID(resultSet.getString("ClienteID"));
					renovacionOrdenPago.setInstitucionID(resultSet.getString("InstitucionID"));
					renovacionOrdenPago.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
					renovacionOrdenPago.setNumOrdenPago(resultSet.getString("NumOrdenPago"));
					renovacionOrdenPago.setMonto(resultSet.getString("Monto"));
					renovacionOrdenPago.setFecha(resultSet.getString("Fecha"));
					renovacionOrdenPago.setBeneficiario(resultSet.getString("Beneficiario"));
					renovacionOrdenPago.setEstatus(resultSet.getString("Estatus"));
					renovacionOrdenPago.setReferencia(resultSet.getString("Referencia"));
					renovacionOrdenPago.setConcepto(resultSet.getString("Concepto"));
					renovacionOrdenPago.setMotivoRenov(resultSet.getString("MotivoRenov"));

					return renovacionOrdenPago;
				}
			});
		consultaOrdenesEmitidas= matches.size() > 0 ? (RenovacionOrdenPagoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Ordenes de pago emitidas", e);
		}
		return consultaOrdenesEmitidas;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

}
