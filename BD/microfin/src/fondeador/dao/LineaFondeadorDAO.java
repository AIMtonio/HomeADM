package fondeador.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tarjetas.bean.TarjetaDebitoBean;

import java.sql.ResultSetMetaData;

import fondeador.bean.LineaFondeadorBean;

public class LineaFondeadorDAO extends BaseDAO{

	public LineaFondeadorDAO() {
		super();
	}

	// ------------------ Transacciones ------------------------------------------

	/* Alta del Cliente */
	public MensajeTransaccionBean alta(final LineaFondeadorBean lineaFondeadorBean) {
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
									String query = "call LINEAFONDEADORALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?,"+
										"?,?,?,?,?, ?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_InstitutFondID",Utileria.convierteEntero(lineaFondeadorBean.getInstitutFondID()));
									sentenciaStore.setString("Par_DescripLinea",lineaFondeadorBean.getDescripLinea());
									sentenciaStore.setDate("Par_FechInicLinea",OperacionesFechas.conversionStrDate(lineaFondeadorBean.getFechInicLinea()));
									sentenciaStore.setDate("Par_FechaFinLinea",OperacionesFechas.conversionStrDate(lineaFondeadorBean.getFechaFinLinea()));
									sentenciaStore.setInt("Par_TipoLinFondeaID",Utileria.convierteEntero(lineaFondeadorBean.getTipoLinFondeaID()));

									sentenciaStore.setDouble("Par_MontoOtorgado",Utileria.convierteDoble(lineaFondeadorBean.getMontoOtorgado()));
									sentenciaStore.setDouble("Par_SaldoLinea",Utileria.convierteDoble(lineaFondeadorBean.getSaldoLinea()));
									sentenciaStore.setDouble("Par_TasaPasiva",Utileria.convierteDoble(lineaFondeadorBean.getTasaPasiva()));
									sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(lineaFondeadorBean.getFactorMora()));
									sentenciaStore.setInt("Par_DiasGraciaMora",Utileria.convierteEntero(lineaFondeadorBean.getDiasGraciaMora()));

									sentenciaStore.setString("Par_PagoAutoVenci",lineaFondeadorBean.getPagoAutoVenci());
									sentenciaStore.setDate("Par_FechaMaxVenci",OperacionesFechas.conversionStrDate(lineaFondeadorBean.getFechaMaxVenci()));
									sentenciaStore.setString("Par_CobraMoratorios",lineaFondeadorBean.getCobraMoratorios());
									sentenciaStore.setString("Par_CobraFaltaPago",lineaFondeadorBean.getCobraFaltaPago());
									sentenciaStore.setInt("Par_DiasGraFaltaPag",Utileria.convierteEntero(lineaFondeadorBean.getDiasGraFaltaPag()));

									sentenciaStore.setDouble("Par_MontoComFaltaPag",Utileria.convierteDoble(lineaFondeadorBean.getMontoComFaltaPag()));
									sentenciaStore.setString("Par_EsRevolvente",lineaFondeadorBean.getEsRevolvente());
									sentenciaStore.setString("Par_TipoRevolvencia",lineaFondeadorBean.getTipoRevolvencia());
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(lineaFondeadorBean.getInstitucionID()));
									sentenciaStore.setString("Par_NumCtaInstit",lineaFondeadorBean.getNumCtaInstit());

									sentenciaStore.setString("Par_CuentaClabe",lineaFondeadorBean.getCuentaClabe());
									sentenciaStore.setString("Par_AfectacionConta",lineaFondeadorBean.getAfectacionConta());
									sentenciaStore.setString("Par_ReqIntegracion",lineaFondeadorBean.getReqIntegra());
									sentenciaStore.setString("Par_TipoCobroMora",lineaFondeadorBean.getTipCobComMorato());
									sentenciaStore.setString("Par_FolioFondeo", lineaFondeadorBean.getFolioFondeo());

									sentenciaStore.setInt("Par_CalcInteresID", Utileria.convierteEntero(lineaFondeadorBean.getCalcInteresID()));
									sentenciaStore.setString("Par_Refinanciamiento", lineaFondeadorBean.getRefinanciamiento());
									sentenciaStore.setInt("Par_TasaBase", Utileria.convierteEntero(lineaFondeadorBean.getTasaBase()));
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(lineaFondeadorBean.getMonedaID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									//Parametros de OutPut
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
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();
										java.sql.ResultSetMetaData metaDatos;

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
										metaDatos = resultadosStore.getMetaData();
										loggerSAFI.info("MetaDatos con "+metaDatos.getColumnCount());
										if(metaDatos.getColumnCount()== 5){
											mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));// PARA OBTENER EL NUMERO DE LA POLIZA
										}else{
											mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);// PARA OBTENER EL NUMERO DE LA POLIZA
										}

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " LineaFondeadorDAO.alta");
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
							throw new Exception(Constantes.MSG_ERROR + " LineaFondeadorDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Linea de Fondeo" + e);
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

	/* Modificacion de  Linea Fondeador*/
	public MensajeTransaccionBean modifica(final LineaFondeadorBean lineaFondeadorBean) {
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
									String query = "call LINEAFONDEADORMOD("
										+ "?,?,?,?,?,	"
										+ "?,?,?,?,?,	"

										+ "?,?,?,?,?,	"
										+ "?,?,?,?,?,	"

										+ "?,?,?,?,?,	"
										+ "?,?,?,?,?,	"

										+ "?,?,?,?,?,	"
										+ "?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(lineaFondeadorBean.getLineaFondeoID()));
									sentenciaStore.setInt("Par_InstitutFondID",Utileria.convierteEntero(lineaFondeadorBean.getInstitutFondID()));
									sentenciaStore.setString("Par_DescripLinea",lineaFondeadorBean.getDescripLinea());
									sentenciaStore.setInt("Par_TipoLinFondeaID",Utileria.convierteEntero(lineaFondeadorBean.getTipoLinFondeaID()));
									sentenciaStore.setDouble("Par_MontoOtorgado",Utileria.convierteDoble(lineaFondeadorBean.getMontoOtorgado()));

									sentenciaStore.setDouble("Par_SaldoLinea",Utileria.convierteDoble(lineaFondeadorBean.getSaldoLinea()));
									sentenciaStore.setDouble("Par_TasaPasiva",Utileria.convierteDoble(lineaFondeadorBean.getTasaPasiva()));
									sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(lineaFondeadorBean.getFactorMora()));
									sentenciaStore.setInt("Par_DiasGraciaMora",Utileria.convierteEntero(lineaFondeadorBean.getDiasGraciaMora()));
									sentenciaStore.setString("Par_PagoAutoVenci",lineaFondeadorBean.getPagoAutoVenci());

									sentenciaStore.setString("Par_CobraMoratorios",lineaFondeadorBean.getCobraMoratorios());
									sentenciaStore.setString("Par_CobraFaltaPago",lineaFondeadorBean.getCobraFaltaPago());
									sentenciaStore.setInt("Par_DiasGraFaltaPag",Utileria.convierteEntero(lineaFondeadorBean.getDiasGraFaltaPag()));
									sentenciaStore.setDouble("Par_MontoComFaltaPag",Utileria.convierteDoble(lineaFondeadorBean.getMontoComFaltaPag()));
									sentenciaStore.setString("Par_EsRevolvente",lineaFondeadorBean.getEsRevolvente());

									sentenciaStore.setString("Par_TipoRevolvencia",lineaFondeadorBean.getTipoRevolvencia());
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(lineaFondeadorBean.getInstitucionID()));
									sentenciaStore.setString("Par_NumCtaInstit",lineaFondeadorBean.getNumCtaInstit());
									sentenciaStore.setString("Par_CuentaClabe",lineaFondeadorBean.getCuentaClabe());
									sentenciaStore.setString("Par_AfectacionConta",lineaFondeadorBean.getAfectacionConta());

									sentenciaStore.setString("Par_ReqIntegracion",lineaFondeadorBean.getReqIntegra());
									sentenciaStore.setString("Par_TipoCobroMora",lineaFondeadorBean.getTipCobComMorato());
									sentenciaStore.setString("Par_FolioFondeo", lineaFondeadorBean.getFolioFondeo());
									sentenciaStore.setInt("Par_CalcInteresID", Utileria.convierteEntero(lineaFondeadorBean.getCalcInteresID()));
									sentenciaStore.setString("Par_Refinanciamiento", lineaFondeadorBean.getRefinanciamiento());
									sentenciaStore.setInt("Par_TasaBase", Utileria.convierteEntero(lineaFondeadorBean.getTasaBase()));
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(lineaFondeadorBean.getMonedaID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									//Parametros de OutPut
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " LineaFondeadorDAO.modifica");
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
							throw new Exception(Constantes.MSG_ERROR + " LineaFondeadorDAO.modifica");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de linea de Fondeo" + e);
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

	/* Consuta LineaFondeador por Llave Principal*/
	public LineaFondeadorBean consultaPrincipal(LineaFondeadorBean lineaFond, int tipoConsulta) {
		LineaFondeadorBean lineaFondConsultaBean = new LineaFondeadorBean();
		try{
			//Query con el Store Procedure
			String query = "call LINEAFONDEADORCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	lineaFond.getLineaFondeoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"LineaFondeadorDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEAFONDEADORCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					LineaFondeadorBean lineaFond = new LineaFondeadorBean();
					lineaFond.setLineaFondeoID(String.valueOf(resultSet.getInt("LineaFondeoID")));
					lineaFond.setInstitutFondID(String.valueOf(resultSet.getInt("InstitutFondID")));
					lineaFond.setDescripLinea(resultSet.getString("DescripLinea"));
					lineaFond.setFechInicLinea(resultSet.getString("FechInicLinea"));
					lineaFond.setFechaFinLinea(resultSet.getString("FechaFinLinea"));

					lineaFond.setTipoLinFondeaID(resultSet.getString("TipoLinFondeaID"));
					lineaFond.setMontoOtorgado(resultSet.getString("MontoOtorgado"));
					lineaFond.setSaldoLinea(resultSet.getString("SaldoLinea"));
					lineaFond.setTasaPasiva(resultSet.getString("TasaPasiva"));
					lineaFond.setFactorMora(resultSet.getString("FactorMora"));

					lineaFond.setDiasGraciaMora(resultSet.getString("DiasGraciaMora"));
					lineaFond.setPagoAutoVenci(resultSet.getString("PagoAutoVenci"));
					lineaFond.setFechaMaxVenci(resultSet.getString("FechaMaxVenci"));
					lineaFond.setCobraMoratorios(resultSet.getString("CobraMoratorios"));
					lineaFond.setCobraFaltaPago(resultSet.getString("CobraFaltaPago"));

					lineaFond.setDiasGraFaltaPag(resultSet.getString("DiasGraFaltaPag"));
					lineaFond.setMontoComFaltaPag(resultSet.getString("MontoComFalPag"));
					lineaFond.setEsRevolvente(resultSet.getString("EsRevolvente"));
					lineaFond.setTipoRevolvencia(resultSet.getString("TipoRevolvencia"));
					lineaFond.setInstitucionID(resultSet.getString("InstitucionID"));
					lineaFond.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
					lineaFond.setCuentaClabe(resultSet.getString("CuentaClabe"));
					lineaFond.setAfectacionConta(resultSet.getString("AfectacionConta"));
					lineaFond.setReqIntegracion(resultSet.getString("ReqIntegracion"));
					lineaFond.setTipCobComMorato(resultSet.getString("TipoCobroMora"));
					lineaFond.setFolioFondeo(resultSet.getString("FolioFondeo"));

					lineaFond.setCalcInteresID(resultSet.getString("CalcInteresID"));
					lineaFond.setTasaBase(resultSet.getString("TasaBase"));
					lineaFond.setRefinanciamiento(resultSet.getString("Refinancia"));
					lineaFond.setMonedaID(resultSet.getString("MonedaID"));
					return lineaFond;
				}
			});
			lineaFondConsultaBean= matches.size() > 0 ? (LineaFondeadorBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta principal de linea de Fondeo: " + e);
		}
		return lineaFondConsultaBean;
	}


	/* Consuta LineaFondeador por Llave Foranea*/
	public LineaFondeadorBean consultaForanea(LineaFondeadorBean lineaFond, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call LINEAFONDEADORCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {	lineaFond.getLineaFondeoID(),
												tipoConsulta,
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO,
												Constantes.FECHA_VACIA,
												Constantes.STRING_VACIO,
												"LineaFondeadorDAO.consultaForanea",
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEAFONDEADORCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LineaFondeadorBean lineaFond = new LineaFondeadorBean();
				lineaFond.setLineaFondeoID(String.valueOf(resultSet.getInt(1)));
				lineaFond.setDescripLinea(resultSet.getString(2));
					return lineaFond;

			}
		});

		return matches.size() > 0 ? (LineaFondeadorBean) matches.get(0) : null;
	}

	/* Consuta LineaFondeador para RedesCuento*/
	public LineaFondeadorBean consultaRedesCto(LineaFondeadorBean lineaFond, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call LINEAFONDEADORCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {	lineaFond.getLineaFondeoID(),
												tipoConsulta,
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO,
												Constantes.FECHA_VACIA,
												Constantes.STRING_VACIO,
												"LineaFondeadorDAO.consultaForanea",
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEAFONDEADORCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LineaFondeadorBean lineaFond = new LineaFondeadorBean();
				lineaFond.setLineaFondeoID(String.valueOf(resultSet.getInt("LineaFondeoID")));
				lineaFond.setDescripLinea(resultSet.getString("DescripLinea"));
				lineaFond.setTipoLinFondeaID(String.valueOf(resultSet.getInt("TipoLinFondeaID")));
				lineaFond.setMontoOtorgado(resultSet.getString("MontoOtorgado"));
				lineaFond.setSaldoLinea(resultSet.getString("SaldoLinea"));
				lineaFond.setInstitutFondID(resultSet.getString("InstitutFondID"));
				lineaFond.setInstitucionID(resultSet.getString("InstitucionID"));
				lineaFond.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
				lineaFond.setCuentaClabe(resultSet.getString("CuentaClabe"));
				return lineaFond;
			}
		});

		return matches.size() > 0 ? (LineaFondeadorBean) matches.get(0) : null;
	}
	/* Consuta LineaFondeador para  condiciones de línea de Fondeo*/
	public LineaFondeadorBean consultaCondiLinea(LineaFondeadorBean lineaFond, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call LINEAFONDEADORCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {	lineaFond.getLineaFondeoID(),
												tipoConsulta,
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO,
												Constantes.FECHA_VACIA,
												Constantes.STRING_VACIO,
												"LineaFondeadorDAO.consultaForanea",
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEAFONDEADORCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LineaFondeadorBean lineaFond = new LineaFondeadorBean();
				lineaFond.setLineaFondeoID(String.valueOf(resultSet.getInt("LineaFondeoID")));
				lineaFond.setInstitutFondID(String.valueOf(resultSet.getInt("InstitutFondID")));
				lineaFond.setDescripLinea(resultSet.getString("DescripLinea"));
				lineaFond.setFechInicLinea(resultSet.getString("FechInicLinea"));
				lineaFond.setFechaFinLinea(resultSet.getString("FechaFinLinea"));
				lineaFond.setMontoOtorgado(resultSet.getString("MontoOtorgado"));
		    	lineaFond.setTipoLinFondeaID(resultSet.getString("TipoLinFondeaID"));
				lineaFond.setMontoOtorgado(resultSet.getString("MontoOtorgado"));
				lineaFond.setSaldoLinea(resultSet.getString("SaldoLinea"));
				lineaFond.setFechaMaxVenci(resultSet.getString("FechaMaxVenci"));

				return lineaFond;
			}
		});

		return matches.size() > 0 ? (LineaFondeadorBean) matches.get(0) : null;
	}
	/* Lista de Linea Fondeador */
	public List listaPrincipal(LineaFondeadorBean lineaFond, int tipoLista) {
		//Query con el Store Procedure
		String query = "call LINEAFONDEADORLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								lineaFond.getDescripLinea(),
								Utileria.convierteEntero(lineaFond.getInstitutFondID()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"LineaFondeadorDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEAFONDEADORLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LineaFondeadorBean lineaFond = new LineaFondeadorBean();
				lineaFond.setLineaFondeoID(String.valueOf(resultSet.getInt(1)));
				lineaFond.setDescripLinea(resultSet.getString(2));
					return lineaFond;
			}
		});

		return matches;
	}
	/* Lista de Linea por Fondeador */
	public List listaForanea(LineaFondeadorBean lineaFond, int tipoLista) {
		//Query con el Store Procedure
		String query = "call LINEAFONDEADORLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								lineaFond.getDescripLinea(),
								Utileria.convierteEntero(lineaFond.getInstitutFondID()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"LineaFondeadorDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEAFONDEADORLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LineaFondeadorBean lineaFond = new LineaFondeadorBean();
				lineaFond.setLineaFondeoID(String.valueOf(resultSet.getInt(1)));
				lineaFond.setDescripLinea(resultSet.getString(2));
					return lineaFond;
			}
		});

		return matches;
	}

	/* Lista de Linea por fondeador */
	public List listaLineaPorFondeador(LineaFondeadorBean lineaFond, int tipoLista) {
		//Query con el Store Procedure
		String query = "call LINEAFONDEADORLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								lineaFond.getDescripLinea(),
								Utileria.convierteEntero(lineaFond.getInstitutFondID()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"LineaFondeadorDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEAFONDEADORLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LineaFondeadorBean lineaFond = new LineaFondeadorBean();
				lineaFond.setLineaFondeoID(String.valueOf(resultSet.getInt(1)));
				lineaFond.setDescripLinea(resultSet.getString(2));
					return lineaFond;
			}
		});

		return matches;
	}

	//------------- actualizacion  para Asociar una tarjeta de Crédito a una cuentaCliente----------------------
	public MensajeTransaccionBean actualiza(final LineaFondeadorBean lineaFond) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call LINEAFONDEADORACT(?,?,?,?,?,?,      ?,?,?,   ?,?,?,?,?,?,? );";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_LineaFondeoID",lineaFond.getLineaFondeoID());
								sentenciaStore.setString("Par_InstitutFondID",lineaFond.getInstitutFondID());
								sentenciaStore.setString("Par_FechaInicLinea",Utileria.convierteFecha(lineaFond.getFechInicLinea()));
								sentenciaStore.setString("Par_FechaFinLinea",Utileria.convierteFecha(lineaFond.getFechaFinLinea()));
								sentenciaStore.setString("Par_FechaMaxVenci",Utileria.convierteFecha(lineaFond.getFechaMaxVenci()));
								sentenciaStore.setString("Par_MontoAumentar",lineaFond.getMontoAumentar());

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
									ResultSetMetaData metaDatos;

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									metaDatos = (ResultSetMetaData) resultadosStore.getMetaData();
									if(metaDatos.getColumnCount()== 5){
										mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));// PARA OBTENER EL NUMERO DE LA POLIZA
									}else{
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);// PARA OBTENER EL NUMERO DE LA POLIZA
									}

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " LineaFondeadorDAO.alta");
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
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualiza tarjeta ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

}

