package regulatorios.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

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

import regulatorios.bean.RegulatorioD0842Bean;

public class RegulatorioD0842DAO extends BaseDAO{


	public RegulatorioD0842DAO() {
		super();
	}

	// Lista para el grid del Regulatorio 0842
		public List lista( RegulatorioD0842Bean regulatorioD0842Bean, int tipoLista){
		List listaGrid = null;

		try{

			String query = "call `HIS-REGULATORIO0842LIS`(?,?,?,?,?,  ?,?,?,?,?);";
			Object[] parametros = {
						Utileria.convierteEntero(regulatorioD0842Bean.getAnio()),
						Utileria.convierteEntero(regulatorioD0842Bean.getMes()),
						tipoLista,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"DiasPasoVencidoDAO.listaDiasPVenProducto",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call `HIS-REGULATORIO0842LIS`(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RegulatorioD0842Bean regulatorioD0842Bean = new RegulatorioD0842Bean();

					regulatorioD0842Bean.setNumeroIden(resultSet.getString("NumeroIden"));
					regulatorioD0842Bean.setTipoPrestamista(resultSet.getString("TipoPrestamista"));
					regulatorioD0842Bean.setClavePrestamista(resultSet.getString("ClavePrestamista"));
					regulatorioD0842Bean.setNumeroContrato(resultSet.getString("NumeroContrato"));
					regulatorioD0842Bean.setNumeroCuenta(resultSet.getString("NumeroCuenta"));
					regulatorioD0842Bean.setFechaContra(resultSet.getString("FechaContra"));
					regulatorioD0842Bean.setFechaVencim(resultSet.getString("FechaVencim"));
					regulatorioD0842Bean.setTasaAnual(resultSet.getString("TasaAnual"));
					regulatorioD0842Bean.setPlazo(resultSet.getString("Plazo"));
					regulatorioD0842Bean.setPeriodoPago(resultSet.getString("PeriodoPago"));
					regulatorioD0842Bean.setMontoRecibido(resultSet.getString("MontoRecibido"));
					regulatorioD0842Bean.setTipoCredito(resultSet.getString("TipoCredito"));
					regulatorioD0842Bean.setDestino(resultSet.getString("Destino"));
					regulatorioD0842Bean.setTipoGarantia(resultSet.getString("TipoGarantia"));
					regulatorioD0842Bean.setMontoGarantia(resultSet.getString("MontoGarantia"));
					regulatorioD0842Bean.setFechaPago(resultSet.getString("FechaPago"));
					regulatorioD0842Bean.setMontoPago(resultSet.getString("MontoPago"));
					regulatorioD0842Bean.setClasificaCortLarg(resultSet.getString("ClasificaCortLarg"));
					regulatorioD0842Bean.setSalInsoluto(resultSet.getString("SalInsoluto"));


					return regulatorioD0842Bean;
				}
			});
			listaGrid= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Historial del Regulatorio D0842 ", e);

		}
		return listaGrid;
	}


		private String getMes() {
			// TODO Auto-generated method stub
			return null;
		}

		private String getAnio() {
			// TODO Auto-generated method stub
			return null;
		}

		public MensajeTransaccionBean grabaRegulatorioD0842(final RegulatorioD0842Bean regulatorioD0842Bean,final ArrayList listaRegulatorioD0842,final int tipoBaja) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();

			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						RegulatorioD0842Bean registroD0842;
						if(listaRegulatorioD0842!=null){
							mensajeBean = bajaRegulatorioD0842( regulatorioD0842Bean, tipoBaja);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}

						}

						if(listaRegulatorioD0842!=null){
							for(int i=0; i<listaRegulatorioD0842.size(); i++){
								registroD0842 = (RegulatorioD0842Bean)listaRegulatorioD0842.get(i);
								mensajeBean = altaRegulatorioD0842(registroD0842,regulatorioD0842Bean);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
					}

						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Operación Realizada Exitosamente");
						mensajeBean.setNombreControl("producCreditoID");
						mensajeBean.setConsecutivoInt(Constantes.STRING_CERO);
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al registrar Regulatorio D0842", e);
						if(mensajeBean.getNumero()==0){
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


		public MensajeTransaccionBean bajaRegulatorioD0842(final RegulatorioD0842Bean regulatorioD0842Bean,final int tipoBja) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call `HIS-REGULATORIO0842BAJ`(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(regulatorioD0842Bean.getAnio()));
									sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(regulatorioD0842Bean.getMes()));
									sentenciaStore.setInt("Par_TipoBaja",tipoBja);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Historial Regulatorio D0842", e);
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

		public MensajeTransaccionBean altaRegulatorioD0842(final RegulatorioD0842Bean regulatorioD0842Bean,final RegulatorioD0842Bean regulatorioD0842) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call `HIS-REGULATORIO0842ALT`(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(regulatorioD0842Bean.getAnio()));
									sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(regulatorioD0842Bean.getMes()));
									sentenciaStore.setString("Par_NumeroIden",regulatorioD0842Bean.getNumeroIden());
									sentenciaStore.setString("Par_TipoPrestamista",regulatorioD0842Bean.getTipoPrestamista());
									sentenciaStore.setString("Par_ClavePrestamista",regulatorioD0842Bean.getClavePrestamista());

									sentenciaStore.setString("Par_NumeroContrato",regulatorioD0842Bean.getNumeroContrato());
									sentenciaStore.setString("Par_NumeroCuenta",regulatorioD0842Bean.getNumeroCuenta());
									sentenciaStore.setString("Par_FechaContra",regulatorioD0842Bean.getFechaContra());
									sentenciaStore.setString("Par_FechaVencim",regulatorioD0842Bean.getFechaVencim());
									sentenciaStore.setFloat("Par_TasaAnual",Utileria.convierteFlotante(regulatorioD0842Bean.getTasaAnual()));

									sentenciaStore.setString("Par_Plazo",regulatorioD0842Bean.getPlazo());
									sentenciaStore.setString("Par_PeriodoPago",regulatorioD0842Bean.getPeriodoPago());
									sentenciaStore.setDouble("Par_MontoRecibido",Utileria.convierteDoble(regulatorioD0842Bean.getMontoRecibido()));
									sentenciaStore.setString("Par_TipoCredito",regulatorioD0842Bean.getTipoCredito());
									sentenciaStore.setString("Par_Destino",regulatorioD0842Bean.getDestino());

									sentenciaStore.setString("Par_TipoGarantia",regulatorioD0842Bean.getTipoGarantia());
									sentenciaStore.setDouble("Par_MontoGarantia",Utileria.convierteDoble(regulatorioD0842Bean.getMontoGarantia()));
									sentenciaStore.setString("Par_FechaPago",regulatorioD0842Bean.getFechaPago());
									sentenciaStore.setDouble("Par_MontoPago",Utileria.convierteDoble(regulatorioD0842Bean.getMontoPago()));
									sentenciaStore.setString("Par_ClasificaCortLarg",regulatorioD0842Bean.getClasificaCortLarg());

									sentenciaStore.setDouble("Par_SalInsoluto",Utileria.convierteDoble(regulatorioD0842Bean.getSalInsoluto()));
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());

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
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Historial Regulatorio D0842", e);
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


		public MensajeTransaccionBean grabaRegulatorioD0842003(final RegulatorioD0842Bean regulatorioD0842Bean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REGULATORIOD0842003ALT(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(regulatorioD0842Bean.getAnio()));
									sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(regulatorioD0842Bean.getMes()));
									sentenciaStore.setString("Par_NumeroIden",regulatorioD0842Bean.getNumeroIden());
									sentenciaStore.setInt("Par_TipoPrestamista",Utileria.convierteEntero(regulatorioD0842Bean.getTipoPrestamista()));
									sentenciaStore.setInt("Par_PaisEntidadExt",Utileria.convierteEntero(regulatorioD0842Bean.getPaisEntidadExtranjera()));

									sentenciaStore.setString("Par_NumeroCuenta",regulatorioD0842Bean.getNumeroCuenta());
									sentenciaStore.setString("Par_NumeroContrato",regulatorioD0842Bean.getNumeroContrato());
									sentenciaStore.setString("Par_ClasificaConta",regulatorioD0842Bean.getClasificaConta());
									sentenciaStore.setDate("Par_FechaContra",herramientas.OperacionesFechas.conversionStrDate(regulatorioD0842Bean.getFechaContra()));
									sentenciaStore.setDate("Par_FechaVencim",herramientas.OperacionesFechas.conversionStrDate(regulatorioD0842Bean.getFechaVencim()));

									sentenciaStore.setInt("Par_PeriodoPago",Utileria.convierteEntero(regulatorioD0842Bean.getPeriodo()));
									sentenciaStore.setDouble("Par_MontoInicial",Utileria.convierteDoble(regulatorioD0842Bean.getMontoRecibido()));
									sentenciaStore.setDouble("Par_MontoInicialMNX",Utileria.convierteDoble(regulatorioD0842Bean.getMontoInicialPrestamo()));
									sentenciaStore.setInt("Par_TipoTasa",Utileria.convierteEntero(regulatorioD0842Bean.getTipoTasa()));
									sentenciaStore.setDouble("Par_ValorTasa",Utileria.convierteDoble(regulatorioD0842Bean.getValTasaOriginal()));

									sentenciaStore.setDouble("Par_ValorTasaInt",Utileria.convierteDoble(regulatorioD0842Bean.getValTasaInt()));
									sentenciaStore.setInt("Par_TasaIntRef",Utileria.convierteEntero(regulatorioD0842Bean.getTasaIntReferencia()));
									sentenciaStore.setDouble("Par_DifTasaRefere",Utileria.convierteDoble(regulatorioD0842Bean.getDiferenciaTasaRef()));
									sentenciaStore.setInt("Par_OperaDifTasaRef",Utileria.convierteEntero(regulatorioD0842Bean.getOperaDifTasaRefe()));
									sentenciaStore.setInt("Par_FrecRevTasa",Utileria.convierteEntero(regulatorioD0842Bean.getFrecRevisionTasa()));

									sentenciaStore.setInt("Par_TipoMoneda",Utileria.convierteEntero(regulatorioD0842Bean.getTipoMoneda()));
									sentenciaStore.setDouble("Par_PorcentajeCom",Utileria.convierteDoble(regulatorioD0842Bean.getPorcentajeComision()));
									sentenciaStore.setDouble("Par_ImporteComision",Utileria.convierteDoble(regulatorioD0842Bean.getImporteComision()));
									sentenciaStore.setInt("Par_PeriodoComision",Utileria.convierteEntero(regulatorioD0842Bean.getPeriodoPago()));
									sentenciaStore.setInt("Par_TipoDispCredito",Utileria.convierteEntero(regulatorioD0842Bean.getTipoDisposicionCredito()));

									sentenciaStore.setInt("Par_DestinoCredito",Utileria.convierteEntero(regulatorioD0842Bean.getDestino()));
									sentenciaStore.setInt("Par_ClasificaCortLarg",Utileria.convierteEntero(regulatorioD0842Bean.getClasificaCortLarg()));
									sentenciaStore.setDouble("Par_SaldoIniPeriodo",Utileria.convierteDoble(regulatorioD0842Bean.getSaldoInicio()));
									sentenciaStore.setDouble("Par_PagosPeriodo",Utileria.convierteDoble(regulatorioD0842Bean.getPagosRealizados()));
									sentenciaStore.setDouble("Par_ComPagadasPeriodo",Utileria.convierteDoble(regulatorioD0842Bean.getComisionPagada()));

									sentenciaStore.setDouble("Par_InteresPagado",Utileria.convierteDoble(regulatorioD0842Bean.getInteresesPagados()));
									sentenciaStore.setDouble("Par_InteresDevengado",Utileria.convierteDoble(regulatorioD0842Bean.getInteresesDevengados()));
									sentenciaStore.setDouble("Par_SaldoCierre",Utileria.convierteDoble(regulatorioD0842Bean.getSaldoCierre()));
									sentenciaStore.setDouble("Par_PorcentajeLinRev",Utileria.convierteDoble(regulatorioD0842Bean.getPorcentajeLinRevolvente()));
									sentenciaStore.setDate("Par_FechaUltPago",herramientas.OperacionesFechas.conversionStrDate(regulatorioD0842Bean.getFechaUltPago()));

									sentenciaStore.setInt("Par_PagoAnticipado",Utileria.convierteEntero(regulatorioD0842Bean.getPagoAnticipado()));
									sentenciaStore.setDouble("Par_MontoUltimoPago",Utileria.convierteDoble(regulatorioD0842Bean.getMontoUltimoPago()));
									sentenciaStore.setDate("Par_FechaPagoSig",herramientas.OperacionesFechas.conversionStrDate(regulatorioD0842Bean.getFechaPagoInmediato()));
									sentenciaStore.setDouble("Par_MonImediato",Utileria.convierteDoble(regulatorioD0842Bean.getMontoPagoInmediato()));
									sentenciaStore.setInt("Par_TipoGarantia",Utileria.convierteEntero(regulatorioD0842Bean.getTipoGarantia()));

									sentenciaStore.setDouble("Par_MontoGarantia",Utileria.convierteDoble(regulatorioD0842Bean.getMontoGarantia()));
									sentenciaStore.setDate("Par_FechaValuaGaran",herramientas.OperacionesFechas.conversionStrDate(regulatorioD0842Bean.getFechaValuacionGaran()));
									sentenciaStore.setInt("Par_PlazoVencin",Utileria.convierteEntero(regulatorioD0842Bean.getPlazo()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

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
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Historial Regulatorio D0842", e);
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


		public MensajeTransaccionBean modRegulatorioD0842003(final RegulatorioD0842Bean regulatorioD0842Bean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REGULATORIOD0842003MOD(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_IdentificadorID",Utileria.convierteEntero(regulatorioD0842Bean.getIdentificadorID()));
									sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(regulatorioD0842Bean.getAnio()));
									sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(regulatorioD0842Bean.getMes()));
									sentenciaStore.setString("Par_NumeroIden",regulatorioD0842Bean.getNumeroIden());
									sentenciaStore.setInt("Par_TipoPrestamista",Utileria.convierteEntero(regulatorioD0842Bean.getTipoPrestamista()));
									sentenciaStore.setInt("Par_PaisEntidadExt",Utileria.convierteEntero(regulatorioD0842Bean.getPaisEntidadExtranjera()));

									sentenciaStore.setString("Par_NumeroCuenta",regulatorioD0842Bean.getNumeroCuenta());
									sentenciaStore.setString("Par_NumeroContrato",regulatorioD0842Bean.getNumeroContrato());
									sentenciaStore.setString("Par_ClasificaConta",regulatorioD0842Bean.getClasificaConta());
									sentenciaStore.setDate("Par_FechaContra",herramientas.OperacionesFechas.conversionStrDate(regulatorioD0842Bean.getFechaContra()));
									sentenciaStore.setDate("Par_FechaVencim",herramientas.OperacionesFechas.conversionStrDate(regulatorioD0842Bean.getFechaVencim()));

									sentenciaStore.setInt("Par_PeriodoPago",Utileria.convierteEntero(regulatorioD0842Bean.getPeriodo()));
									sentenciaStore.setDouble("Par_MontoInicial",Utileria.convierteDoble(regulatorioD0842Bean.getMontoRecibido()));
									sentenciaStore.setDouble("Par_MontoInicialMNX",Utileria.convierteDoble(regulatorioD0842Bean.getMontoInicialPrestamo()));
									sentenciaStore.setInt("Par_TipoTasa",Utileria.convierteEntero(regulatorioD0842Bean.getTipoTasa()));
									sentenciaStore.setDouble("Par_ValorTasa",Utileria.convierteDoble(regulatorioD0842Bean.getValTasaOriginal()));

									sentenciaStore.setDouble("Par_ValorTasaInt",Utileria.convierteDoble(regulatorioD0842Bean.getValTasaInt()));
									sentenciaStore.setInt("Par_TasaIntRef",Utileria.convierteEntero(regulatorioD0842Bean.getTasaIntReferencia()));
									sentenciaStore.setDouble("Par_DifTasaRefere",Utileria.convierteDoble(regulatorioD0842Bean.getDiferenciaTasaRef()));
									sentenciaStore.setInt("Par_OperaDifTasaRef",Utileria.convierteEntero(regulatorioD0842Bean.getOperaDifTasaRefe()));
									sentenciaStore.setInt("Par_FrecRevTasa",Utileria.convierteEntero(regulatorioD0842Bean.getFrecRevisionTasa()));

									sentenciaStore.setInt("Par_TipoMoneda",Utileria.convierteEntero(regulatorioD0842Bean.getTipoMoneda()));
									sentenciaStore.setDouble("Par_PorcentajeCom",Utileria.convierteDoble(regulatorioD0842Bean.getPorcentajeComision()));
									sentenciaStore.setDouble("Par_ImporteComision",Utileria.convierteDoble(regulatorioD0842Bean.getImporteComision()));
									sentenciaStore.setInt("Par_PeriodoComision",Utileria.convierteEntero(regulatorioD0842Bean.getPeriodoPago()));
									sentenciaStore.setInt("Par_TipoDispCredito",Utileria.convierteEntero(regulatorioD0842Bean.getTipoDisposicionCredito()));

									sentenciaStore.setInt("Par_DestinoCredito",Utileria.convierteEntero(regulatorioD0842Bean.getDestino()));
									sentenciaStore.setInt("Par_ClasificaCortLarg",Utileria.convierteEntero(regulatorioD0842Bean.getClasificaCortLarg()));
									sentenciaStore.setDouble("Par_SaldoIniPeriodo",Utileria.convierteDoble(regulatorioD0842Bean.getSaldoInicio()));
									sentenciaStore.setDouble("Par_PagosPeriodo",Utileria.convierteDoble(regulatorioD0842Bean.getPagosRealizados()));
									sentenciaStore.setDouble("Par_ComPagadasPeriodo",Utileria.convierteDoble(regulatorioD0842Bean.getComisionPagada()));

									sentenciaStore.setDouble("Par_InteresPagado",Utileria.convierteDoble(regulatorioD0842Bean.getInteresesPagados()));
									sentenciaStore.setDouble("Par_InteresDevengado",Utileria.convierteDoble(regulatorioD0842Bean.getInteresesDevengados()));
									sentenciaStore.setDouble("Par_SaldoCierre",Utileria.convierteDoble(regulatorioD0842Bean.getSaldoCierre()));
									sentenciaStore.setDouble("Par_PorcentajeLinRev",Utileria.convierteDoble(regulatorioD0842Bean.getPorcentajeLinRevolvente()));
									sentenciaStore.setDate("Par_FechaUltPago",herramientas.OperacionesFechas.conversionStrDate(regulatorioD0842Bean.getFechaUltPago()));

									sentenciaStore.setInt("Par_PagoAnticipado",Utileria.convierteEntero(regulatorioD0842Bean.getPagoAnticipado()));
									sentenciaStore.setDouble("Par_MontoUltimoPago",Utileria.convierteDoble(regulatorioD0842Bean.getMontoUltimoPago()));
									sentenciaStore.setDate("Par_FechaPagoSig",herramientas.OperacionesFechas.conversionStrDate(regulatorioD0842Bean.getFechaPagoInmediato()));
									sentenciaStore.setDouble("Par_MonImediato",Utileria.convierteDoble(regulatorioD0842Bean.getMontoPagoInmediato()));
									sentenciaStore.setInt("Par_TipoGarantia",Utileria.convierteEntero(regulatorioD0842Bean.getTipoGarantia()));

									sentenciaStore.setDouble("Par_MontoGarantia",Utileria.convierteDoble(regulatorioD0842Bean.getMontoGarantia()));
									sentenciaStore.setDate("Par_FechaValuaGaran",herramientas.OperacionesFechas.conversionStrDate(regulatorioD0842Bean.getFechaValuacionGaran()));
									sentenciaStore.setInt("Par_PlazoVencin",Utileria.convierteEntero(regulatorioD0842Bean.getPlazo()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

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
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de Historial Regulatorio D0842", e);
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


		public MensajeTransaccionBean eliminaRegulatorioD0842003(final RegulatorioD0842Bean regulatorioD0842Bean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REGULATORIOD0842003BAJ(?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_IdentificadorID",Utileria.convierteEntero(regulatorioD0842Bean.getIdentificadorID()));
									sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(regulatorioD0842Bean.getAnio()));
									sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(regulatorioD0842Bean.getMes()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

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
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en eliminacion de Historial Regulatorio D0842", e);
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

		/* Consulta Instituciones de Fondeo por Llave Principal*/
		public RegulatorioD0842Bean consultaPrincipal(RegulatorioD0842Bean regulatorioD0842Bean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call REGULATORIOD0842003CON(?,?,?,?,?, ?,?,?,?,?, ?);";

			Object[] parametros = {	regulatorioD0842Bean.getIdentificadorID(),
									regulatorioD0842Bean.getAnio(),
									regulatorioD0842Bean.getMes(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"RegulatorioD0842.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD0842003CON(" +Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RegulatorioD0842Bean regulatorioD0842 = new RegulatorioD0842Bean();


					regulatorioD0842.setIdentificadorID(String.valueOf(resultSet.getInt("Consecutivo")));
					regulatorioD0842.setAnio(resultSet.getString("Anio"));
					regulatorioD0842.setMes(resultSet.getString("Mes"));
					regulatorioD0842.setPeriodo(resultSet.getString("PeriodoPago"));
					regulatorioD0842.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					regulatorioD0842.setFormulario(resultSet.getString("Formulario"));
					regulatorioD0842.setNumeroIden(resultSet.getString("NumeroIden"));
					regulatorioD0842.setTipoPrestamista(resultSet.getString("TipoPrestamista"));
					regulatorioD0842.setPaisEntidadExtranjera(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt("PaisEntidadExt"),3)));
					regulatorioD0842.setNumeroCuenta(resultSet.getString("NumeroCuenta"));
					regulatorioD0842.setNumeroContrato(resultSet.getString("NumeroContrato"));
					regulatorioD0842.setClasificaConta(resultSet.getString("ClasificaConta"));
					regulatorioD0842.setFechaContra(resultSet.getString("FechaContra"));
					regulatorioD0842.setFechaVencim(resultSet.getString("FechaVencim"));
					regulatorioD0842.setPeriodoPago(resultSet.getString("PeriodoPago"));
					regulatorioD0842.setMontoRecibido(resultSet.getString("MontoInicial"));
					regulatorioD0842.setMontoInicialPrestamo(resultSet.getString("MontoInicialMNX"));
					regulatorioD0842.setTipoTasa(resultSet.getString("TipoTasa"));
					regulatorioD0842.setValTasaOriginal(resultSet.getString("ValorTasa"));
					regulatorioD0842.setValTasaInt(resultSet.getString("ValorTasaInt"));
					regulatorioD0842.setTasaIntReferencia(resultSet.getString("TasaIntReferencia"));
					regulatorioD0842.setDiferenciaTasaRef(resultSet.getString("DifTasaReferencia"));
					regulatorioD0842.setOperaDifTasaRefe(resultSet.getString("OperaDifTasaRefe"));
					regulatorioD0842.setFrecRevisionTasa(resultSet.getString("FrecRevTasa"));
					regulatorioD0842.setTipoMoneda(resultSet.getString("TipoMoneda"));
					regulatorioD0842.setPorcentajeComision(resultSet.getString("PorcentajeComision"));
					regulatorioD0842.setImporteComision(resultSet.getString("ImporteComision"));
					regulatorioD0842.setPeriodoPago(resultSet.getString("PeriodoComision"));
					regulatorioD0842.setTipoDisposicionCredito(resultSet.getString("TipoDispCredito"));
					regulatorioD0842.setDestino(resultSet.getString("DestinoCredito"));
					regulatorioD0842.setClasificaCortLarg(resultSet.getString("ClasificaCortLarg"));
					regulatorioD0842.setSaldoInicio(resultSet.getString("SaldoIniPeriodo"));
					regulatorioD0842.setPagosRealizados(resultSet.getString("PagosPeriodo"));
					regulatorioD0842.setComisionPagada(resultSet.getString("ComPagadasPeriodo"));
					regulatorioD0842.setInteresesPagados(resultSet.getString("InteresPagado"));
					regulatorioD0842.setInteresesDevengados(resultSet.getString("InteresDevengados"));
					regulatorioD0842.setSaldoCierre(resultSet.getString("SaldoCierre"));
					regulatorioD0842.setPorcentajeLinRevolvente(resultSet.getString("PorcentajeLinRev"));
					regulatorioD0842.setFechaUltPago(resultSet.getString("FechaUltPago"));
					regulatorioD0842.setPagoAnticipado(resultSet.getString("PagoAnticipado"));
					regulatorioD0842.setMontoUltimoPago(resultSet.getString("MontoUltimoPago"));
					regulatorioD0842.setFechaPagoInmediato(resultSet.getString("FechaPagoSig"));
					regulatorioD0842.setMontoPagoInmediato(resultSet.getString("MontoPagImediato"));
					regulatorioD0842.setTipoGarantia(resultSet.getString("TipoGarantia"));
					regulatorioD0842.setMontoGarantia(resultSet.getString("MontoGarantia"));
					regulatorioD0842.setFechaValuacionGaran(resultSet.getString("FechaValuaGaran"));
					regulatorioD0842.setPlazo(resultSet.getString("PlazoVencimiento"));



						return regulatorioD0842;

				}
			});

			return matches.size() > 0 ? (RegulatorioD0842Bean) matches.get(0) : null;
		}
		// LISTA PRINCIPAL

		public List listaRegulatorio(RegulatorioD0842Bean regulatorioD0842Bean, int tipoLista) {
			//Query con el Store Procedure
			List matches;
			String query = "call REGULATORIOD0842003LIS(?,?,?,?,?, ?,?,?,?,?,?);";
		try{
				Object[] parametros = {
						regulatorioD0842Bean.getAnio(),
						regulatorioD0842Bean.getMes(),
						regulatorioD0842Bean.getDescripcion(),
						tipoLista,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"listaRegulatorio.consultaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD0842003LIS(" + Arrays.toString(parametros) +")");

				 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RegulatorioD0842Bean regulatorioD0842 = new RegulatorioD0842Bean();
					regulatorioD0842.setIdentificadorID(resultSet.getString("Consecutivo"));
					regulatorioD0842.setDescripcion(resultSet.getString("Descripcion"));
					regulatorioD0842.setNumeroContrato(resultSet.getString("NumeroContrato"));

				return regulatorioD0842;
				}
			});

		}catch(Exception e){
			matches = new ArrayList();
			e.printStackTrace();
		}

			return matches;
		}


		/**
		 * Consulta para generar el reporte en Excel regulatorio D0842
		 * @param bean
		 * @param tipoReporte
		 * @return
		 */
		public List <RegulatorioD0842Bean> reporteRegulatorioD0842(final RegulatorioD0842Bean bean, int tipoReporte){
			transaccionDAO.generaNumeroTransaccion();
			String query = "call `HIS-REGULATORIO0842LIS`(?,?,?,?,?,  ?,?,?,?,?);";

			Object[] parametros ={
								Utileria.convierteEntero(bean.getAnio()),
								Utileria.convierteEntero(bean.getMes()),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call HIS-REGULATORIO0842LIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RegulatorioD0842Bean beanResponse= new RegulatorioD0842Bean();
					beanResponse.setPeriodo(resultSet.getString("Periodo"));
					beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					beanResponse.setFormulario(resultSet.getString("Formulario"));
					beanResponse.setNumeroIden(resultSet.getString("NumeroIden"));
					beanResponse.setTipoPrestamista(resultSet.getString("TipoPrestamista"));
					beanResponse.setClavePrestamista(resultSet.getString("ClavePrestamista"));
					beanResponse.setNumeroContrato(resultSet.getString("NumeroContrato"));

					beanResponse.setNumeroCuenta(resultSet.getString("NumeroCuenta"));
					beanResponse.setFechaContra(resultSet.getString("FechaContra"));
					beanResponse.setFechaVencim(resultSet.getString("FechaVencim"));
					beanResponse.setTasaAnual(resultSet.getString("TasaAnual"));
					beanResponse.setPlazo(resultSet.getString("Plazo"));

					beanResponse.setPeriodoPago(resultSet.getString("PeriodoPago"));
					beanResponse.setMontoRecibido(resultSet.getString("MontoRecibido"));
					beanResponse.setTipoCredito(resultSet.getString("TipoCredito"));
					beanResponse.setDestino(resultSet.getString("Destino"));
					beanResponse.setTipoGarantia(resultSet.getString("TipoGarantia"));

					beanResponse.setMontoGarantia(resultSet.getString("MontoGarantia"));
					beanResponse.setFechaPago(resultSet.getString("FechaPago"));
					beanResponse.setMontoPago(resultSet.getString("MontoPago"));
					beanResponse.setClasificaCortLarg(resultSet.getString("ClasificaCortLarg"));
					beanResponse.setSalInsoluto(resultSet.getString("SalInsoluto"));


					return beanResponse ;
				}
			});
			return matches;
		}
		/**
		 * Consulta para generar el reporte en Excel regulatorio D0842 para sofipos
		 * @param bean
		 * @param tipoReporte
		 * @return
		 */
		public List <RegulatorioD0842Bean> reporteRegulatorioD0842003(final RegulatorioD0842Bean bean, int tipoReporte){
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGULATORIOD0842003REP(?,?,?,?,?,  ?,?,?,?,?);";

			Object[] parametros ={
								Utileria.convierteEntero(bean.getAnio()),
								Utileria.convierteEntero(bean.getMes()),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD0842003REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RegulatorioD0842Bean beanResponse= new RegulatorioD0842Bean();
					beanResponse.setPeriodoRep(resultSet.getString("Periodo"));
					beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					beanResponse.setFormulario(resultSet.getString("Formulario"));
					beanResponse.setNumeroIden(resultSet.getString("NumeroIden"));
					beanResponse.setTipoPrestamista(resultSet.getString("TipoPrestamista"));
					beanResponse.setPaisEntidadExtranjera(resultSet.getString("PaisEntidadExt"));
					beanResponse.setNumeroCuenta(resultSet.getString("NumeroCuenta"));
					beanResponse.setNumeroContrato(resultSet.getString("NumeroContrato"));
					beanResponse.setClasificaConta(resultSet.getString("ClasificaConta"));
					beanResponse.setFechaContra(resultSet.getString("FechaContra"));
					beanResponse.setFechaVencim(resultSet.getString("FechaVencim"));
					beanResponse.setPlazo(resultSet.getString("PlazoVencimiento"));
					beanResponse.setMontoRecibido(resultSet.getString("MontoInicial"));
					beanResponse.setMontoInicialPrestamo(resultSet.getString("MontoInicialMNX"));
					beanResponse.setTipoTasa(resultSet.getString("TipoTasa"));
					beanResponse.setValTasaOriginal(resultSet.getString("ValorTasa"));
					beanResponse.setValTasaInt(resultSet.getString("ValorTasaInt"));
					beanResponse.setTasaIntReferencia(resultSet.getString("TasaIntReferencia"));
					beanResponse.setDiferenciaTasaRef(resultSet.getString("DifTasaReferencia"));
					beanResponse.setOperaDifTasaRefe(resultSet.getString("OperaDifTasaRefe"));
					beanResponse.setFrecRevisionTasa(resultSet.getString("FrecRevTasa"));
					beanResponse.setTipoMoneda(resultSet.getString("TipoMoneda"));
					beanResponse.setPorcentajeComision(resultSet.getString("PorcentajeComision"));
					beanResponse.setImporteComision(resultSet.getString("ImporteComision"));
					beanResponse.setPeriodoPago(resultSet.getString("PeriodoComision"));
					beanResponse.setTipoDisposicionCredito(resultSet.getString("TipoDispCredito"));
					beanResponse.setDestino(resultSet.getString("DestinoCredito"));
					beanResponse.setClasificaCortLarg(resultSet.getString("ClasificaCortLarg"));
					beanResponse.setSaldoInicio(resultSet.getString("SaldoIniPeriodo"));
					beanResponse.setPeriodo(resultSet.getString("PeriodoPago"));
					beanResponse.setPagosRealizados(resultSet.getString("PagosPeriodo"));
					beanResponse.setComisionPagada(resultSet.getString("ComPagadasPeriodo"));
					beanResponse.setInteresesPagados(resultSet.getString("InteresPagado"));
					beanResponse.setInteresesDevengados(resultSet.getString("InteresDevengados"));
					beanResponse.setSaldoCierre(resultSet.getString("SaldoCierre"));
					beanResponse.setPorcentajeLinRevolvente(resultSet.getString("PorcentajeLinRev"));
					beanResponse.setFechaUltPago(resultSet.getString("FechaUltPago"));
					beanResponse.setPagoAnticipado(resultSet.getString("PagoAnticipado"));
					beanResponse.setMontoUltimoPago(resultSet.getString("MontoUltimoPago"));
					beanResponse.setFechaPagoInmediato(resultSet.getString("FechaPagoSig"));
					beanResponse.setMontoPagoInmediato(resultSet.getString("MontoPagImediato"));
					beanResponse.setTipoGarantia(resultSet.getString("TipoGarantia"));
					beanResponse.setMontoGarantia(resultSet.getString("MontoGarantia"));
					beanResponse.setFechaValuacionGaran(resultSet.getString("FechaValuaGaran"));

					return beanResponse ;
				}
			});
			return matches;
		}
		/**
		 * Consulta del reporte regulatorio  version CSV
		 * @param bean
		 * @param tipoReporte
		 * @return
		 */
		public List <RegulatorioD0842Bean>reporteRegulatorioD0842003Csv(final RegulatorioD0842Bean bean, int tipoReporte){
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGULATORIOD0842003REP(?,?,?,?,?,  ?,?,?,?,?);";

			Object[] parametros ={
						Utileria.convierteEntero(bean.getAnio()),
						Utileria.convierteEntero(bean.getMes()),
						tipoReporte,
			    		parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD0842003REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RegulatorioD0842Bean beanResponse= new RegulatorioD0842Bean();
					beanResponse.setRenglon(resultSet.getString("Renglon"));

					return beanResponse ;
				}
			});
			return matches;
		}


		public List <RegulatorioD0842Bean>reporteRegulatorioD0842Csv(final RegulatorioD0842Bean bean, int tipoReporte){
			transaccionDAO.generaNumeroTransaccion();
			String query = "call `HIS-REGULATORIO0842LIS`(?,?,?,?,?,  ?,?,?,?,?);";

			Object[] parametros ={
								Utileria.convierteEntero(bean.getAnio()),
								Utileria.convierteEntero(bean.getMes()),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call HIS-REGULATORIO0842LIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RegulatorioD0842Bean beanResponse= new RegulatorioD0842Bean();
					beanResponse.setRenglon(resultSet.getString("Renglon"));

					return beanResponse ;
				}
			});
			return matches;
		}




}
