package fondeador.dao;
import fondeador.bean.AmortizaFondeoBean;
import fondeador.beanWS.request.ConsultaAmortiFondeoBERequest;
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

public class AmortizaFondeoDAO extends BaseDAO{

	public AmortizaFondeoDAO() {
		super();
	}

	// actualiza los campos de capital para uso del simulador de pagos libres de credito fondeo
	public MensajeTransaccionBean actualizacionSimuladorCapitalFondeo(final AmortizaFondeoBean amortizaFondeoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
			String query = "call CREPAGLIBAMORACT(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					amortizaFondeoBean.getAmortizacionID(),
					amortizaFondeoBean.getCapital().replace(",", ""),

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"AmortizacionDAO.actualizacionSimuladorCapital",
					parametrosAuditoriaBean.getSucursal(),
					amortizaFondeoBean.getNumTransaccion()

			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREPAGLIBAMORACT(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					return mensaje;
				}
			});
			mensaje =  matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
		} catch (Exception e) {

			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar de campos de capital", e);
			}
			mensaje.setDescripcion(e.getMessage());
		}
		return mensaje;
	}

	// inserta los campos de fecha de inicio, de vencimiento y  capital para uso del simulador de pagos libres
	public MensajeTransaccionBean altaSimuladorFechaCapitalFondeo(final AmortizaFondeoBean amortizaFondeoBean, final String diaHabil) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREPAGLIBAMORALT("
											+ "?,?,?,?,?,      "
											+ "?,?,?,?,?,      "
											+ "?,?,?,?,?)";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_Consecutivo", Utileria.convierteEntero(amortizaFondeoBean.getAmortizacionID()));
								sentenciaStore.setDouble("Par_Capital", Utileria.convierteDoble(amortizaFondeoBean.getCapital()));
								sentenciaStore.setString("Par_FechaInicio", amortizaFondeoBean.getFechaInicio());
								sentenciaStore.setString("Par_FechaVenc", amortizaFondeoBean.getFechaVencim());
								sentenciaStore.setString("Par_DiaHabilSig", diaHabil);
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
								return sentenciaStore;
							}
						}, new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if (callableStatement.execute()) {
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Amortizacion Fondeo Pagos Libres: " + mensajeBean.getDescripcion());
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Amortizacion Fondeo Pagos Libres", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error en Alta de Amortizacion Pagos Libres.");
			ex.printStackTrace();
		}
		return mensaje;
	}

	/* Muestra las amortizaciones vigentes menores a la fecha del sistema*/
	public List listaConsultaAmortiCredVig(final AmortizaFondeoBean amortiCredFonBean, int tipoLista){
		String query = "call AMORTIZAFONDEOLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros ={
				            amortiCredFonBean.getCreditoFondeoID(),
				    		tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"AmortizacionCreditoDAO.listaConsultaAmortiCred",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTIZAFONDEOLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			@Override
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AmortizaFondeoBean amorticredBean= new AmortizaFondeoBean();
				amorticredBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				amorticredBean.setFechaInicio(resultSet.getString("FechaInicio"));
				amorticredBean.setFechaVencim(resultSet.getString("FechaVencimiento"));
				amorticredBean.setEstatus(resultSet.getString("Estatus"));
				amorticredBean.setCapital(resultSet.getString("Capital"));
				amorticredBean.setInteres(resultSet.getString("Interes"));
				amorticredBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
				amorticredBean.setSaldoComFaltaPago(resultSet.getString("SaldoComFaltaPa"));
				amorticredBean.setSaldoOtrasComisiones(resultSet.getString("SaldoOtrasComis"));
				amorticredBean.setEstatusAmortiza(resultSet.getString("EstatusAmortiza"));
				return amorticredBean ;
			}
		});
		return matches;
	}

	/* muestra todas las amortizaciones filtradas por credito pasivo */
	public List listaAmortizacionesCredito(final AmortizaFondeoBean amortiCredFonBean, int tipoLista){
		String query = "call AMORTIZAFONDEOLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros ={
				            amortiCredFonBean.getCreditoFondeoID(),
				    		tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"AmortizacionCreditoDAO.listaConsultaAmortiCred",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTIZAFONDEOLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			@Override
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AmortizaFondeoBean amorticredBean= new AmortizaFondeoBean();
				amorticredBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				amorticredBean.setFechaInicio(resultSet.getString("FechaInicio"));
				amorticredBean.setFechaVencim(resultSet.getString("FechaVencimiento"));
				amorticredBean.setFechaExigible(resultSet.getString("FechaExigible"));
				amorticredBean.setEstatus(resultSet.getString("Estatus"));

				amorticredBean.setEstatusAmortiza(resultSet.getString("EstatusAmortiza"));
				amorticredBean.setCapital(resultSet.getString("Capital"));
				amorticredBean.setInteres(resultSet.getString("Interes"));
				amorticredBean.setIvaInteres(resultSet.getString("IVAInteres"));
				amorticredBean.setSaldoCapital(resultSet.getString("SaldoCapital"));

				amorticredBean.setSaldoCapVigente(resultSet.getString("SaldoCapVigente"));
				amorticredBean.setSaldoCapAtrasa(resultSet.getString("SaldoCapAtrasad"));
				amorticredBean.setSaldoInteresPro(resultSet.getString("SaldoInteresPro"));
				amorticredBean.setSaldoInteresAtra(resultSet.getString("SaldoInteresAtra"));
				amorticredBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));

				amorticredBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
				amorticredBean.setSaldoIVAMora(resultSet.getString("SaldoIVAMora"));
				amorticredBean.setSaldoComFaltaPago(resultSet.getString("SaldoComFaltaPa"));
				amorticredBean.setSaldoIVAComFalP(resultSet.getString("SaldoIVAComFalP"));
				amorticredBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));

				amorticredBean.setSaldoIVAOtrCom(resultSet.getString("SaldoIVAOtrCom"));
				amorticredBean.setTotalCuota(resultSet.getString("TotalCuota"));
				amorticredBean.setMontoCuota(resultSet.getString("MontoCuota"));
				amorticredBean.setRetencion(resultSet.getString("Retencion"));
				amorticredBean.setSaldoRetencion(resultSet.getString("SaldoRetencion"));
				return amorticredBean ;
			}
		});
		return matches;
	}


	/* Muestra las amortizaciones */
	public List listaConsultaAmorti(final ConsultaAmortiFondeoBERequest amortiCredFonBean, int tipoLista){
		String query = "call AMORTIZAFONDEOLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros ={
				            Utileria.convierteLong(amortiCredFonBean.getCreditoFondeoID()),
				    		tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"AmortizacionCreditoDAO.listaConsultaAmortiCred",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTIZAFONDEOLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			@Override
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AmortizaFondeoBean amorticredBean= new AmortizaFondeoBean();
				amorticredBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				amorticredBean.setFechaInicio(resultSet.getString("FechaInicio"));
				amorticredBean.setFechaVencim(resultSet.getString("FechaVencimiento"));
				amorticredBean.setEstatus(resultSet.getString("Estatus"));
				amorticredBean.setCapital(resultSet.getString("Capital"));
				amorticredBean.setInteres(resultSet.getString("Interes"));
				amorticredBean.setSaldoIVAInteres(resultSet.getString("IVAInteres"));
				amorticredBean.setTotalCuota(resultSet.getString("TotalCuota"));

				return amorticredBean ;
			}
		});
		return matches;
	}

}
