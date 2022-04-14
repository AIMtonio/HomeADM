package credito.dao;
import fira.bean.MinistracionCredAgroBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
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

import originacion.bean.SolicitudCreditoBean;

import credito.bean.AmortizacionCreditoBean;
import credito.bean.CreditosBean;
import credito.beanWS.request.ConsultaAmortiCreditoBERequest;
import credito.beanWS.request.ConsultaDetallePagosRequest;
import credito.beanWS.response.ConsultaDetallePagosResponse;
public class AmortizacionCreditoDAO extends BaseDAO  {

	public AmortizacionCreditoDAO() {
		super();
	}
	CreditosDAO creditosDAO = null;

	public List listaConsultaAmortiCred(final AmortizacionCreditoBean amorticredBean, int tipoLista){
		String query = "call AMORTICREDITOLIS(?,?, ?,?,?,?,?,?,?);";

		Object[] parametros ={
				    		amorticredBean.getCreditoID(),
				    		tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"AmortizacionCreditoDAO.listaConsultaAmortiCred",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			@Override
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AmortizacionCreditoBean amorticredBean= new AmortizacionCreditoBean();
				amorticredBean.setAmortizacionID(String.valueOf(resultSet.getInt("AmortizacionID")));
				amorticredBean.setFechaInicio(resultSet.getString("FechaInicio"));
				amorticredBean.setFechaVencim(resultSet.getString("FechaVencim"));
				amorticredBean.setFechaExigible(resultSet.getString("FechaExigible"));
				amorticredBean.setEstatus(resultSet.getString("Estatus"));
				amorticredBean.setCapital(resultSet.getString("Capital"));
				amorticredBean.setInteres(resultSet.getString("Interes"));
				amorticredBean.setIvaInteres(resultSet.getString("IVAInteres"));
				amorticredBean.setSaldoCapital(resultSet.getString("SaldoCapital"));

				amorticredBean.setSaldoCapVigente(resultSet.getString("SaldoCapVigente"));
				amorticredBean.setSaldoCapAtrasado(resultSet.getString("SaldoCapAtrasa"));
				amorticredBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
				amorticredBean.setSaldoCapVNE(resultSet.getString("SaldoCapVenNExi"));

				amorticredBean.setSaldoIntProvisionado(resultSet.getString("SaldoInteresPro"));
				amorticredBean.setSaldoIntAtrasado(resultSet.getString("SaldoInteresAtr"));
				amorticredBean.setSaldoIntVencido(resultSet.getString("SaldoInteresVen"));
				amorticredBean.setSaldoIntCalNoCont(resultSet.getString("SaldoIntNoConta"));
				amorticredBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));

				amorticredBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
				amorticredBean.setSaldoIVAMora(resultSet.getString("SaldoIVAMora"));

				amorticredBean.setSaldoComFaltaPago(resultSet.getString("SaldoComFaltaPa"));
				amorticredBean.setSaldoIVAComFaltaPago(resultSet.getString("SaldoIVAComFalPag"));

				amorticredBean.setSaldoOtrasComisiones(resultSet.getString("SaldoOtrasComis"));
				amorticredBean.setSaldoIVAOtrasCom(resultSet.getString("SaldoIVAOtrCom"));
				amorticredBean.setTotalPago(resultSet.getString("TotalCuota"));
				amorticredBean.setMontoCuota(resultSet.getString("MontoCuota"));
				amorticredBean.setTotalCap(resultSet.getString("Var_TotalCap"));
				amorticredBean.setTotalInteres(resultSet.getString("Var_TotalInt"));
				amorticredBean.setTotalIva(resultSet.getString("Var_TotalIva"));
				amorticredBean.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
				amorticredBean.setCobraIVASeguroCuota(resultSet.getString("CobraIVASeguroCuota"));
				amorticredBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
				amorticredBean.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
				amorticredBean.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
				amorticredBean.setTotalIVASeguroCuota(resultSet.getString("TotalIVASeguroCuota"));
				amorticredBean.setSaldoSeguroCuota(resultSet.getString("SaldoSeguroCuota"));
				amorticredBean.setSaldoIVASeguroCuota(resultSet.getString("SaldoIVASeguroCuota"));
				amorticredBean.setMontoOtrasComisiones(resultSet.getString("MontoOtrasComisiones"));
				amorticredBean.setMontoIVAOtrasComisiones(resultSet.getString("MontoIVAOtrasComisiones"));
				amorticredBean.setTotalOtrasComisiones(resultSet.getString("TotalOtrasComisiones"));
				amorticredBean.setTotalIVAOtrasComisiones(resultSet.getString("TotalIVAOtrasComisiones"));

				amorticredBean.setSaldoNotasCargo(resultSet.getString("SaldoNotasCargo"));
				amorticredBean.setMontoIvaNotaCargo(resultSet.getString("MontoIvaNotaCargo"));
				return amorticredBean ;
			}

		});

		return matches;
	}

	// Lista de amortizaciones del credito para la pantalla de Pagaré de Crédito
	public List listaConsultaAmortiCredPagare(final AmortizacionCreditoBean amorticredBean, int tipoLista){
		String query = "call AMORTICREDITOLIS(?,?, ?,?,?,?,?,?,?);";

		Object[] parametros ={
				    		amorticredBean.getCreditoID(),
				    		tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"AmortizacionCreditoDAO.listaConsultaAmortiCred",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			@Override
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				// TODO Auto-generated method stub
				AmortizacionCreditoBean amorticredBean= new AmortizacionCreditoBean();
				amorticredBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				amorticredBean.setFechaInicio(resultSet.getString("FechaInicio"));
				amorticredBean.setFechaVencim(resultSet.getString("FechaVencim"));
				amorticredBean.setFechaExigible(resultSet.getString("FechaExigible"));
				amorticredBean.setEstatus(resultSet.getString("Estatus"));
				amorticredBean.setCapital(resultSet.getString("Capital"));
				amorticredBean.setInteres(resultSet.getString("Interes"));
				amorticredBean.setIvaInteres(resultSet.getString("IVAInteres"));
				amorticredBean.setTotalPago(resultSet.getString("TotalCuota"));
				amorticredBean.setSaldoCapital(resultSet.getString("SaldoCapital"));
				amorticredBean.setTotalCap(resultSet.getString("TotalCapital"));
				amorticredBean.setTotalInteres(resultSet.getString("TotalInteres"));
				amorticredBean.setTotalIva(resultSet.getString("TotalIVA"));
				amorticredBean.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
				amorticredBean.setTotalIVASeguroCuota(resultSet.getString("TotalIVASeguroCuota"));
				amorticredBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
				amorticredBean.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
				amorticredBean.setSaldoOtrasComisiones(resultSet.getString("MontoOtrasComisiones"));
				amorticredBean.setSaldoIVAOtrasCom(resultSet.getString("MontoIVAOtrasComisiones"));
				amorticredBean.setTotalOtrasComisiones(resultSet.getString("TotalOtrasComisiones"));
				amorticredBean.setTotalIVAOtrasComisiones(resultSet.getString("TotalIVAOtrasComisiones"));

				return amorticredBean ;
			}
		});

		return matches;
	}


 public List listaConsultaAmorti(final ConsultaAmortiCreditoBERequest amorticredBean, int tipoLista){

		String query = "call AMORTICREDITOLIS(?,?, ?,?,?,?,?,?,?);";

		Object[] parametros ={
				    		Utileria.convierteLong(amorticredBean.getCreditoID()),
				    		tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"AmortizacionCreditoDAO.listaConsultaAmortiCred",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			@Override
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				// TODO Auto-generated method stub
				AmortizacionCreditoBean amorticredBean= new AmortizacionCreditoBean();
				amorticredBean.setAmortizacionID(resultSet.getString(1));
				amorticredBean.setFechaInicio(resultSet.getString(2));
				amorticredBean.setFechaVencim(resultSet.getString(3));
				amorticredBean.setFechaExigible(resultSet.getString(4));
				amorticredBean.setEstatus(resultSet.getString(5));
				amorticredBean.setCapital(resultSet.getString(6));
				amorticredBean.setInteres(resultSet.getString(7));
				amorticredBean.setIvaInteres(resultSet.getString(8));
				amorticredBean.setTotalPago(resultSet.getString(9));
				amorticredBean.setSaldoCapital(resultSet.getString(10));
				return amorticredBean ;
			}
		});

		return matches;
	}


	//Lista pagare grupal
	public List listaPagareGrupal(int tipoLista, AmortizacionCreditoBean amortiCredBean) {
		List listaPagareGrupal = null;
		try{
			String query = "call CREDITOGRUPALIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								amortiCredBean.getCreditoID(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								OperacionesFechas.FEC_VACIA,
								Constantes.STRING_VACIO,
								"listaPagareGrupal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOGRUPALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				AmortizacionCreditoBean amorticredBean= new AmortizacionCreditoBean();

				amorticredBean.setAmortizacionID(String.valueOf(resultSet.getInt("AmortizacionID")));
				amorticredBean.setFechaInicio(resultSet.getString("FechaInicio"));
				amorticredBean.setFechaVencim(resultSet.getString("FechaVencim"));
				amorticredBean.setFechaExigible(resultSet.getString("FechaExigible"));
				amorticredBean.setEstatus(resultSet.getString("Estatus"));

				amorticredBean.setCapital(resultSet.getString("Capital"));
				amorticredBean.setInteres(resultSet.getString("Interes"));
				amorticredBean.setIvaInteres(resultSet.getString("IVAinteres"));
				amorticredBean.setSaldoCapital(resultSet.getString("MontoCuota"));
				amorticredBean.setSaldoCapVigente(resultSet.getString("SaldoCapVigente"));

				amorticredBean.setSaldoCapAtrasado(resultSet.getString("SaldoCapAtrasa"));
				amorticredBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
				amorticredBean.setSaldoCapVNE(resultSet.getString("SaldoCapVenNExi"));
				amorticredBean.setSaldoIntProvisionado(resultSet.getString("SaldoInteresPro"));
				amorticredBean.setSaldoIntAtrasado(resultSet.getString("SaldoInteresAtr"));

				amorticredBean.setSaldoIntVencido(resultSet.getString("SaldoInteresVen"));
				amorticredBean.setSaldoIntCalNoCont(resultSet.getString("SaldoIntNoConta"));
				amorticredBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));
				amorticredBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
				amorticredBean.setSaldoIVAMora(resultSet.getString("SaldoIVAMora"));

				amorticredBean.setSaldoComFaltaPago(resultSet.getString("SaldoComFaltaPa"));
				amorticredBean.setSaldoIVAComFaltaPago(resultSet.getString("SaldoIVAComFalPag"));
				amorticredBean.setSaldoOtrasComisiones(resultSet.getString("SaldoOtrasComis"));
				amorticredBean.setSaldoIVAOtrasCom(resultSet.getString("SaldoIVAOtrCom"));
				amorticredBean.setTotalPago(resultSet.getString("TotalCuota"));

				return amorticredBean;
			}

		});

		listaPagareGrupal = matches;
	}catch(Exception e){
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de Pagare Grupal", e);

		}
		return listaPagareGrupal;
	}
	// actualiza los campos de capital para uso del simulador de pagos libre
	public MensajeTransaccionBean actualizacionSimuladorCapital(final AmortizacionCreditoBean amortizacionCreditoBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{

			String query = "call CREPAGLIBAMORACT(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					amortizacionCreditoBean.getAmortizacionID(),
					amortizacionCreditoBean.getCapital(),

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"AmortizacionDAO.actualizacionSimuladorCapital",
					parametrosAuditoriaBean.getSucursal(),
					amortizacionCreditoBean.getNumTransaccion()

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
	/**
	 * Inserta los campos del Simulador de Pagos Libres Creditos Pasivos
	 * @param amortizacionCreditoBean : {@link AmortizacionCreditoBean} Bean con los datos de la amortizacion
	 * @param diaHabil : String que especifica si es dia habil la amortizacion
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean altaSimuladorFechaCapital(final AmortizacionCreditoBean amortizacionCreditoBean, final String diaHabil) {
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
								sentenciaStore.setInt("Par_Consecutivo", Utileria.convierteEntero(amortizacionCreditoBean.getAmortizacionID()));
								sentenciaStore.setDouble("Par_Capital", Utileria.convierteDoble(amortizacionCreditoBean.getCapital()));
								sentenciaStore.setString("Par_FechaInicio", amortizacionCreditoBean.getFechaInicio());
								sentenciaStore.setString("Par_FechaVenc", amortizacionCreditoBean.getFechaVencim());
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Amortizacion Pagos Libres: " + mensajeBean.getDescripcion());
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Amortizacion Pagos Libres", e);
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

	public List consultaDetallePagosWS(ConsultaDetallePagosRequest detallePagos, int tipoConsulta){
		final ConsultaDetallePagosResponse mensajeBean = new ConsultaDetallePagosResponse();
		String query = "call AMORTICREDITOWSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(detallePagos.getClienteID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AmortizacionCreditoDAO.consultaDetallePagosWS",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOWSCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConsultaDetallePagosResponse consultaDetalle = new ConsultaDetallePagosResponse();
				consultaDetalle.setInfoDetallePagos(resultSet.getString(1)
						+"&;&"+resultSet.getString(2)+"&;&"+resultSet.getString(3)+"&;&"+resultSet.getString(4));
				consultaDetalle.setCodigoRespuesta(resultSet.getString(5));
				consultaDetalle.setMensajeRespuesta(resultSet.getString(6));
					return consultaDetalle;
				}

		});
		return matches;

	}

	//Consulta de dias de atraso ----------------------------------------
		public AmortizacionCreditoBean consultaDiasAtraso(AmortizacionCreditoBean amortizacionCreditoBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call AMORTICREDITOCON(?,?,? ,?,?,? ,?,?,?);";
			Object[] parametros = { amortizacionCreditoBean.getCreditoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AmortizacionCreditoBean amortizacionCreditoBean = new AmortizacionCreditoBean();
					amortizacionCreditoBean.setDiasAtraso(resultSet.getString(1));
					return amortizacionCreditoBean;
				}
			});
			return matches.size() > 0 ? (AmortizacionCreditoBean) matches.get(0) : null;
		}

		// se usa para validaciones ventanilla prepago de credito
		public String consultaCapVigente(AmortizacionCreditoBean amortizacionCreditoBean, int tipoConsulta) {
			String capitalVigente = "0";

			try{
				String query = "call AMORTICREDITOCON(?,?,  ?,?,?,?,?,?,?);";
				Object[] parametros = {	amortizacionCreditoBean.getCreditoID(),
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"IngresosOperacionesDAO.ConsultaPrincipal",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						String capital = new String();

						capital=resultSet.getString("TotalCapitalVig");
							return capital;
					}
				});
			capitalVigente= matches.size() > 0 ? (String) matches.get(0) : "0";
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Total de Capital Vigente", e);
			}
			return capitalVigente;
		}

		//Consulta CuotasPagadas y el Total de Cuotas

		public AmortizacionCreditoBean consultaCuotas(AmortizacionCreditoBean amortizacionCreditoBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call AMORTICREDITOCON(?,?,? ,?,?,? ,?,?,?);";
			Object[] parametros = { amortizacionCreditoBean.getCreditoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AmortizacionCreditoBean amortizacionCreditoBean = new AmortizacionCreditoBean();
					amortizacionCreditoBean.setCuotasPagadas(resultSet.getString("CuotasPagadas"));
					amortizacionCreditoBean.setTotalCuotas(resultSet.getString("TotalCuotas"));

					return amortizacionCreditoBean;
				}
			});
		  return matches.size() > 0 ? (AmortizacionCreditoBean) matches.get(0) : null;
		}


		//Consulta el saldo final a plazo de un credito para Sana Tus Finanzas

		public AmortizacionCreditoBean consultaSaldoFinalPlazo(AmortizacionCreditoBean amortizacionCreditoBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call AMORTICREDITOCON(?,?,? ,?,?,? ,?,?,?);";
			Object[] parametros = { amortizacionCreditoBean.getCreditoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOCON(" + Arrays.toString(parametros) + ");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AmortizacionCreditoBean amortizacionCreditoBean = new AmortizacionCreditoBean();
					amortizacionCreditoBean.setCreditoID(resultSet.getString("CreditoID"));
					amortizacionCreditoBean.setSaldoFinalPlazo(resultSet.getString("SaldoFinalPlazo"));

					return amortizacionCreditoBean;
				}
			});
		  return matches.size() > 0 ? (AmortizacionCreditoBean) matches.get(0) : null;
		}

	public MensajeTransaccionBean simuladorLibresAgro(final MinistracionCredAgroBean ministracionCredAgroBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call MINISTRACREDAGROALT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_SolicitudCreditoID", Utileria.convierteEntero(ministracionCredAgroBean.getSolicitudCreditoID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ministracionCredAgroBean.getCreditoID()));
								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ministracionCredAgroBean.getClienteID()));
								sentenciaStore.setInt("Par_ProspectoID", Utileria.convierteEntero(ministracionCredAgroBean.getProspectoID()));
								sentenciaStore.setString("Par_FechaPagoMinis", ministracionCredAgroBean.getFechaPagoMinis());
								sentenciaStore.setDouble("Par_Capital", Utileria.convierteDoble(ministracionCredAgroBean.getCapital()));

								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Ministracion: " + mensajeBean.getDescripcion());
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Ministracion", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al dar de alta la Ministracion.");
			ex.printStackTrace();
		}
		return mensaje;
	}
	/**
	 * Lista que se llama en el pagare de credito Agropecuarios.
	 * @param amorticredBean : {@link AmortizacionCreditoBean} Bean con la informacion de las Amortizaciones a consultar
	 * @param tipoLista : Número de Lista
	 * @return : List<{@link AmortizacionCreditoBean}
	 */
	public List<AmortizacionCreditoBean> listaConAmortiCredAgroPagare(final AmortizacionCreditoBean amorticredBean, int tipoLista) {
		String query = "call AMORTICREDITOAGROLIS(?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = { amorticredBean.getCreditoID(), tipoLista, parametrosAuditoriaBean.getEmpresaID(), parametrosAuditoriaBean.getUsuario(), parametrosAuditoriaBean.getFecha(), parametrosAuditoriaBean.getDireccionIP(), "AmortizacionCreditoDAO.listaConsultaAmortiCred", parametrosAuditoriaBean.getSucursal(), Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call AMORTICREDITOAGROLIS(  " + Arrays.toString(parametros) + ")");

		List<AmortizacionCreditoBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			@Override
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AmortizacionCreditoBean amorticredBean = new AmortizacionCreditoBean();
				amorticredBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				amorticredBean.setFechaInicio(resultSet.getString("FechaInicio"));
				amorticredBean.setFechaVencim(resultSet.getString("FechaVencim"));
				amorticredBean.setFechaExigible(resultSet.getString("FechaExigible"));
				amorticredBean.setEstatus(resultSet.getString("Estatus"));
				amorticredBean.setCapital(resultSet.getString("Capital"));
				amorticredBean.setInteres(resultSet.getString("Interes"));
				amorticredBean.setIvaInteres(resultSet.getString("IVAInteres"));
				amorticredBean.setTotalPago(resultSet.getString("TotalCuota"));
				amorticredBean.setSaldoCapital(resultSet.getString("SaldoCapital"));
				amorticredBean.setTotalCap(resultSet.getString("TotalCapital"));
				amorticredBean.setTotalInteres(resultSet.getString("TotalInteres"));
				amorticredBean.setTotalIva(resultSet.getString("TotalIVA"));
				amorticredBean.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
				amorticredBean.setTotalIVASeguroCuota(resultSet.getString("TotalIVASeguroCuota"));
				amorticredBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
				amorticredBean.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
				return amorticredBean;
			}
		});

		return matches;
	}

	public List listaConsultaAmortiCredContingente(final AmortizacionCreditoBean amorticredBean, int tipoLista){

		List listaAmortizacion = null ;
		try{
			String query = "call AMORTICREDITOLIS(?,?, ?,?,?,?,?,?,?);";

			Object[] parametros ={
					    		amorticredBean.getCreditoID(),
					    		tipoLista,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"AmortizacionCreditoDAO.listaConsultaAmortiCredCont",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOLIS(  " + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				@Override
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AmortizacionCreditoBean amorticredBean= new AmortizacionCreditoBean();

					amorticredBean.setAmortizacionID(String.valueOf(resultSet.getInt("AmortizacionID")));
					amorticredBean.setFechaInicio(resultSet.getString("FechaInicio"));
					amorticredBean.setFechaVencim(resultSet.getString("FechaVencim"));
					amorticredBean.setFechaExigible(resultSet.getString("FechaExigible"));
					amorticredBean.setEstatus(resultSet.getString("Estatus"));

					amorticredBean.setCapital(resultSet.getString("Capital"));
					amorticredBean.setInteres(resultSet.getString("Interes"));
					amorticredBean.setIvaInteres(resultSet.getString("IVAInteres"));
					amorticredBean.setSaldoCapital(resultSet.getString("SaldoCapital"));
					amorticredBean.setSaldoCapVigente(resultSet.getString("SaldoCapVigente"));

					amorticredBean.setSaldoCapAtrasado(resultSet.getString("SaldoCapAtrasa"));
					amorticredBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					amorticredBean.setSaldoCapVNE(resultSet.getString("SaldoCapVenNExi"));
					amorticredBean.setSaldoIntProvisionado(resultSet.getString("SaldoInteresPro"));
					amorticredBean.setSaldoIntAtrasado(resultSet.getString("SaldoInteresAtr"));

					amorticredBean.setSaldoIntVencido(resultSet.getString("SaldoInteresVen"));
					amorticredBean.setSaldoIntCalNoCont(resultSet.getString("SaldoIntNoConta"));
					amorticredBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));
					amorticredBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					amorticredBean.setSaldoIVAMora(resultSet.getString("SaldoIVAMora"));

					amorticredBean.setSaldoComFaltaPago(resultSet.getString("SaldoComFaltaPa"));
					amorticredBean.setSaldoIVAComFaltaPago(resultSet.getString("SaldoIVAComFalPag"));
					amorticredBean.setSaldoOtrasComisiones(resultSet.getString("SaldoOtrasComis"));
					amorticredBean.setSaldoIVAOtrasCom(resultSet.getString("SaldoIVAOtrCom"));
					amorticredBean.setTotalPago(resultSet.getString("TotalCuota"));

					amorticredBean.setMontoCuota(resultSet.getString("MontoCuota"));
					amorticredBean.setTotalCap(resultSet.getString("Var_TotalCap"));
					amorticredBean.setTotalInteres(resultSet.getString("Var_TotalInt"));
					amorticredBean.setTotalIva(resultSet.getString("Var_TotalIva"));
					amorticredBean.setSaldoSeguroCuota(resultSet.getString("SaldoSeguroCuota"));

					amorticredBean.setSaldoIVASeguroCuota(resultSet.getString("SaldoIVASeguroCuota"));
					amorticredBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
					amorticredBean.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
					amorticredBean.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
					amorticredBean.setTotalIVASeguroCuota(resultSet.getString("TotalIVASeguroCuota"));

					return amorticredBean ;
				}

			});
			listaAmortizacion = matches;
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en la consulta de amortizaciones contingente: " + e);
			e.printStackTrace();
    	}

		return listaAmortizacion;
    }


	public List listAmortReporteExcel(final AmortizacionCreditoBean amortizacionCreditoBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		CreditosBean creditosBean = new CreditosBean();
		transaccionDAO.generaNumeroTransaccion();
		String tipoOperacionSimulador = "1";

		creditosBean.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
		creditosBean.setClienteID(amortizacionCreditoBean.getClienteID());
		creditosBean.setProducCreditoID(amortizacionCreditoBean.getProducCreditoID());
		creditosBean.setPlazoID(amortizacionCreditoBean.getPlazoID());
		creditosBean.setMontoCredito(amortizacionCreditoBean.getMontoSol());
		creditosBean.setConvenioNominaID(amortizacionCreditoBean.getConvenioNominaID());
		creditosBean.setTipoOpera(tipoOperacionSimulador);

		String cobraAccesorios = amortizacionCreditoBean.getCobraAccesorios();
		String cobraAccesoriosGen = amortizacionCreditoBean.getCobraAccesoriosGen();

		mensaje = new MensajeTransaccionBean();
		if(cobraAccesorios == null) {
			cobraAccesorios = "N";
		}
		if(cobraAccesoriosGen == null) {
			cobraAccesorios = "N";
		}
		if(cobraAccesorios.equalsIgnoreCase("S") && cobraAccesoriosGen.equalsIgnoreCase("S")) {
			mensaje =  creditosDAO.altaAccesorios(creditosBean);
		}

		String query = "call PROYECCIONCREDITOREP(?,?,?,?,?," +
												 "?,?,?,?,?," +
												 "?,?,?,?,?," +
												 "?,?,?,?,?," +
												 "?,?,?,?,?,?," +
												 "?,?,?,?,?,?," +
												 "?,?);";

		Object[] parametros ={
							Utileria.convierteEntero(amortizacionCreditoBean.getConvenioNominaID()),

							amortizacionCreditoBean.getMontoSol(),
							amortizacionCreditoBean.getTasaFija(),
							amortizacionCreditoBean.getFrecuencia(),
							amortizacionCreditoBean.getFrecuenciaInt(),
							amortizacionCreditoBean.getPeriodicidad(),

							amortizacionCreditoBean.getPeriodicidadInt(),
							amortizacionCreditoBean.getDiaPago(),
							amortizacionCreditoBean.getDiaPagoInt(),
							amortizacionCreditoBean.getDiaMes(),
							amortizacionCreditoBean.getDiaMesInt(),

							amortizacionCreditoBean.getFechaInicio(),
							amortizacionCreditoBean.getNumCuotas(),
							amortizacionCreditoBean.getNumCuotasInt(),
							amortizacionCreditoBean.getProducCreditoID(),
							amortizacionCreditoBean.getClienteID(),

							amortizacionCreditoBean.getDiaHabilSig(),
							amortizacionCreditoBean.getAjustaFecAmo(),
							amortizacionCreditoBean.getAjusFecExiVen(),
							amortizacionCreditoBean.getComApertura(),
							amortizacionCreditoBean.getCalculoInt(),

							amortizacionCreditoBean.getTipoCalculoInt(),
							amortizacionCreditoBean.getTipoPagCap(),
							amortizacionCreditoBean.getCat(),
							amortizacionCreditoBean.getCobraSeguroCuota(),
							amortizacionCreditoBean.getCobraIVASeguroCuota(),
							amortizacionCreditoBean.getMontoSeguroCuota(),

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"AmortizacionCreditoDAO.listAmortReporteExcel",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROYECCIONCREDITOREP(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			@Override
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AmortizacionCreditoBean amorticredBean= new AmortizacionCreditoBean();

				amorticredBean.setAmortizacionID(String.valueOf(resultSet.getInt("Cuota")));
				amorticredBean.setFechaInicio(resultSet.getString("FechaInicio"));
				amorticredBean.setFechaVencim(resultSet.getString("FechaVencimiento"));
				amorticredBean.setFechaExigible(resultSet.getString("FechaPago"));
				amorticredBean.setCapital(resultSet.getString("Capital"));

				amorticredBean.setInteres(resultSet.getString("Interes"));
				amorticredBean.setIvaInteres(resultSet.getString("IVAInteres"));

				amorticredBean.setMontoCuota(resultSet.getString("TotalCuota"));
				amorticredBean.setSaldoCapital(resultSet.getString("SaldoCapital"));
				amorticredBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
				amorticredBean.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
				amorticredBean.setMontoOtrasComisiones(resultSet.getString("MontoOtrasComisiones"));
				amorticredBean.setMontoIVAOtrasComisiones(resultSet.getString("MontoIVAOtrasComisiones"));

				return amorticredBean ;
			}
		});

		return matches;
	}
	public void proyectaCreditoAccesorios(final AmortizacionCreditoBean amortizacionCreditoBean,int altabaja){
		CreditosBean creditosBean = new CreditosBean();
		String tipoOperacionSimulador = "1";
		int alta=1;
		int baja=2;

		creditosBean.setNumTransacSim(String.valueOf(amortizacionCreditoBean.getNumTransaccion()));
		creditosBean.setClienteID(amortizacionCreditoBean.getClienteID());
		creditosBean.setProducCreditoID(amortizacionCreditoBean.getProducCreditoID());
		creditosBean.setPlazoID(amortizacionCreditoBean.getPlazoID());
		creditosBean.setMontoCredito(amortizacionCreditoBean.getMontoSol());
		creditosBean.setConvenioNominaID(amortizacionCreditoBean.getConvenioNominaID());
		creditosBean.setTipoOpera(tipoOperacionSimulador);
		String cobraAccesorios="N";
		String cobraAccesoriosGen="N";
		try {
			 cobraAccesorios    = ((!amortizacionCreditoBean.getCobraAccesorios().isEmpty())?amortizacionCreditoBean.getCobraAccesorios():"N");
        } catch (NullPointerException e) {
        	cobraAccesorios="N";
        }
		try {
			 cobraAccesoriosGen = ((!amortizacionCreditoBean.getCobraAccesoriosGen().isEmpty())?amortizacionCreditoBean.getCobraAccesoriosGen():"N");
        } catch (NullPointerException e) {
        	cobraAccesoriosGen="N";
        }

		if(cobraAccesorios.equalsIgnoreCase("S") && cobraAccesoriosGen.equalsIgnoreCase("S")) {
			if (altabaja == alta){

			 creditosDAO.altaAccesorios(creditosBean);

			}else if(altabaja == baja){
				creditosDAO.bajaAccesorios(creditosBean);

			}
		}

	}
	public CreditosDAO getCreditosDAO() {
		return creditosDAO;
	}

	public void setCreditosDAO(CreditosDAO creditosDAO) {
		this.creditosDAO = creditosDAO;
	}

}