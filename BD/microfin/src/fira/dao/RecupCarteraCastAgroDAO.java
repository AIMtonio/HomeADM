package fira.dao;

import fira.bean.RecupCarteraCastAgroBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
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
import credito.dao.CastigosCarteraDAO;


public class RecupCarteraCastAgroDAO extends BaseDAO {

	PolizaDAO				polizaDAO				= null;
	CastigosCarteraDAO		castigosCarteraDAO		= null;
	RecupCarteraCastAgroDAO recupCarteraCastAgroDAO = null;

	final String			saltoLinea				= " <br> ";
	final boolean			origenVent				= false;
	final Integer 			consultaPrincipal = 1;
	final Integer		    consultaAgro = 43;

	/**
	 * Recuperacion de cartera castigada
	 * @return
	 */
	public MensajeTransaccionBean recuperaCarteraCastigada(final RecupCarteraCastAgroBean recupCarteraCastAgroBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		// consulta el monto que tiene pendiente por recuperar el credito
		String montoRecuperar = "";
		montoRecuperar = consultaMontoRecuperar(recupCarteraCastAgroBean, consultaAgro);
		double montoRecu = Double.parseDouble(montoRecuperar);
		double parTotalRecuperar = Double.parseDouble(recupCarteraCastAgroBean.getMonRecuperado());


		if (parTotalRecuperar > montoRecu) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto del Deposito Excede el Total del Monto por Recuperar");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			// SE GENERAN LOS ENCABEZADOS DE LA POLIZA
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			String recuperacionCartera = "63";
			String DesRecuperacionCartera = "Recuperacion de Cartera Castigada";
			while (contador <= 3) {
				contador++;
				recupCarteraCastAgroBean.setConceptoID(recuperacionCartera);
				recupCarteraCastAgroBean.setObservacionesCastigo(DesRecuperacionCartera);
				polizaDAO.generaPolizaCredito(recupCarteraCastAgroBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(recupCarteraCastAgroBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(recupCarteraCastAgroBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {
							// Movimientos Operativos y Contables
							numeroPoliza = recupCarteraCastAgroBean.getPolizaID();
							mensajeBean = recuperacionCarteraVencidaAgro(recupCarteraCastAgroBean, parametrosAuditoriaBean.getNumeroTransaccion());
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}else{
								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
							}
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Recuperacion de Cartera Vencida Agro", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(recupCarteraCastAgroBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}else{
					mensaje.setNumero(0);
					mensaje.setDescripcion("Operación Realizada Exitosamente.");
					mensaje.setNombreControl("numeroTransaccion");
					mensaje.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
				}
				return mensaje;
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}

	/**
	 * Método para realizar el proceso de recuperacion de Cartera Castigada Agro
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean recuperacionCarteraVencidaAgro(final RecupCarteraCastAgroBean recupCarteraCastAgroBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call `CRECASTIGOSAGRORECPRO`(?,?,?,?,?,	?,?,?,?,?, ?,?,	?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(recupCarteraCastAgroBean.getCreditoAgro()));
							sentenciaStore.setInt("Par_CuentaAhoID", Utileria.convierteEntero(recupCarteraCastAgroBean.getCuentaID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(recupCarteraCastAgroBean.getClienteID()));
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(recupCarteraCastAgroBean.getMonRecuperado()));
							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(recupCarteraCastAgroBean.getPolizaID()));

							sentenciaStore.setString("Par_DescripcionMov", recupCarteraCastAgroBean.getObservacionesCastigo());
							sentenciaStore.setDouble("Par_PorcentajeCast", Utileria.convierteDoble(recupCarteraCastAgroBean.getPorcentajeCreditoRec()));
							sentenciaStore.setDouble("Par_PorcentajeCastCont", Utileria.convierteDoble(recupCarteraCastAgroBean.getPorcentajeCreditoRecCont()));
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);

					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de remesas", e);

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

	public RecupCarteraCastAgroBean conCreCastigos(final RecupCarteraCastAgroBean recupCarteraCastAgroBean, final int tipoConsulta){
		RecupCarteraCastAgroBean recupCartCastAgroBean = null;
		try {
			recupCartCastAgroBean = (RecupCarteraCastAgroBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CREDITOSAGROCON(?,?,?,?,?,	?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_CreditoID",recupCarteraCastAgroBean.getCreditoAgro());
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							RecupCarteraCastAgroBean recupCarteraCastAgroBean = new RecupCarteraCastAgroBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								recupCarteraCastAgroBean.setCreditoAgro(resultadosStore.getString("CreditoID"));
								recupCarteraCastAgroBean.setProductoCreditoAgro(resultadosStore.getString("ProductoCreditoID"));
								recupCarteraCastAgroBean.setClienteID(resultadosStore.getString("ClienteID"));
								recupCarteraCastAgroBean.setCuentaID(resultadosStore.getString("CuentaID"));
								recupCarteraCastAgroBean.setMonedaCartAgro(resultadosStore.getString("MonedaID"));


								recupCarteraCastAgroBean.setMontoCreditoCastAgro(resultadosStore.getString("MontoCredito"));
								recupCarteraCastAgroBean.setSaldoCreditoAgro(resultadosStore.getString("SaldoDispon"));
								recupCarteraCastAgroBean.setEstatusCred(resultadosStore.getString("EstatusCredito"));
								recupCarteraCastAgroBean.setFechaCastigo(resultadosStore.getString("FechaActivo"));
								recupCarteraCastAgroBean.setMotivoCastigo(resultadosStore.getString("MotivoActivo"));

								recupCarteraCastAgroBean.setObservacionesCastigo(resultadosStore.getString("ObservActivo"));
								recupCarteraCastAgroBean.setCapitalActivoCast(resultadosStore.getString("CapitalActivo"));
								recupCarteraCastAgroBean.setInteresActivoCast(resultadosStore.getString("InteresActivo"));
								recupCarteraCastAgroBean.setMoratoriosActivosCast(resultadosStore.getString("MoraActivo"));
								recupCarteraCastAgroBean.setComisionesActivasCast(resultadosStore.getString("ComisionActivo"));

								recupCarteraCastAgroBean.setTotalActivoCastigado(resultadosStore.getString("TotalActivo"));
								recupCarteraCastAgroBean.setMontoRecActivoCast(resultadosStore.getString("RecuperadoActivo"));
								recupCarteraCastAgroBean.setMontoxRecActivoCast(resultadosStore.getString("MontoxRecuperarActivo"));

								recupCarteraCastAgroBean.setCapitalContCast(resultadosStore.getString("CapitalCont"));
								recupCarteraCastAgroBean.setInteresContCast(resultadosStore.getString("InteresCont"));
								recupCarteraCastAgroBean.setMoratoriosContCast(resultadosStore.getString("MoraCont"));
								recupCarteraCastAgroBean.setComisionesContCast(resultadosStore.getString("ComisionCont"));
								recupCarteraCastAgroBean.setTotalContCastigado(resultadosStore.getString("TotalCont"));

								recupCarteraCastAgroBean.setMontoRecContCast(resultadosStore.getString("RecuperadoCont"));
								recupCarteraCastAgroBean.setMontoxRecContCast(resultadosStore.getString("MontoxRecuperarCont"));
								recupCarteraCastAgroBean.setEsAgropecuario(resultadosStore.getString("EsAgropecuario"));
								recupCarteraCastAgroBean.setIVAActivoCast(resultadosStore.getString("IVAActivo"));
								recupCarteraCastAgroBean.setIVAContCast(resultadosStore.getString("IVACont"));

							}
							return recupCarteraCastAgroBean;
						}
					});
			return recupCartCastAgroBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de creditos agro: ", e);
			return null;
		}
	}

	// metodo de consulta para validaciones ventanilla recuperacion de cartera castigada
	public String consultaMontoRecuperar(RecupCarteraCastAgroBean recupCarteraCastAgroBean, int tipoConsulta) {
		String montoRecuperar = "0";
		try{
			String query = "call CREDITOSAGROCON(?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	recupCarteraCastAgroBean.getCreditoAgro(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CastigosCarteraDAO.consultaAgro",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSAGROCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String monto = new String();

					monto=resultSet.getString("TotalxRecuperar");
						return monto;
				}
			});
		montoRecuperar= matches.size() > 0 ? (String) matches.get(0) : "0";
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Monto a recuperar", e);
		}
		return montoRecuperar;
	}


	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}
	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}
	public CastigosCarteraDAO getCastigosCarteraDAO() {
		return castigosCarteraDAO;
	}
	public void setCastigosCarteraDAO(CastigosCarteraDAO castigosCarteraDAO) {
		this.castigosCarteraDAO = castigosCarteraDAO;
	}
	public RecupCarteraCastAgroDAO getRecupCarteraCastAgroDAO() {
		return recupCarteraCastAgroDAO;
	}
	public void setRecupCarteraCastAgroDAO(
			RecupCarteraCastAgroDAO recupCarteraCastAgroDAO) {
		this.recupCarteraCastAgroDAO = recupCarteraCastAgroDAO;
	}

	//--------------------------getter y setter-----------------

}
