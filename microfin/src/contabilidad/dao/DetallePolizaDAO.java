package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.bean.CePolizasBean;
import contabilidad.bean.CuentasContablesBean;
import contabilidad.bean.DetallePolizaBean;
import contabilidad.bean.PolizaBean;

public class DetallePolizaDAO extends BaseDAO{
	//Variables
	public DetallePolizaDAO() {
		super();
	}

	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";
	int polizaManual = 17; // tipo de Instrumento Poliza Manual
	public MensajeTransaccionBean alta(final DetallePolizaBean detallePolizaBean, final String consecutivo) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {

							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {


									String query = "call DETALLEPOLIZAALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,?);";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);


									sentenciaStore.setInt("Par_Empresa",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Poliza", consecutivo);
									sentenciaStore.setString("Par_Fecha",detallePolizaBean.getFecha());
									sentenciaStore.setInt("Par_CenCosto", Utileria.convierteEntero(detallePolizaBean.getCentroCostoID()));
									sentenciaStore.setString("Par_Cuenta",detallePolizaBean.getCuentaCompleta());
									sentenciaStore.setString("Par_Instrumento",detallePolizaBean.getInstrumento());
									sentenciaStore.setInt("Par_Moneda",Utileria.convierteEntero(detallePolizaBean.getMonedaID()));
									sentenciaStore.setDouble("Par_Cargos",Utileria.convierteDoble(detallePolizaBean.getCargos()));
									sentenciaStore.setDouble("Par_Abonos",Utileria.convierteDoble(detallePolizaBean.getAbonos()));
									sentenciaStore.setString("Par_Descripcion",detallePolizaBean.getDescripcion());
									sentenciaStore.setString("Par_Referencia",detallePolizaBean.getReferencia());
									sentenciaStore.setString("Par_Procedimiento", "DETALLEPOLIZAALT");
									sentenciaStore.setInt("Par_TipoInstrumentoID", polizaManual);
									sentenciaStore.setString("Par_RFC",detallePolizaBean.getRFC());
									sentenciaStore.setDouble("Par_TotalFact", Utileria.convierteDoble(detallePolizaBean.getTotalFactura()));
									sentenciaStore.setString("Par_FolioUUID",detallePolizaBean.getFolioUUID());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);


									//Parametros de Auditoria

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .detallePolizaDAO.alta");
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
							throw new Exception(Constantes.MSG_ERROR + " .detallePolizaDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de la Poliza" + e);
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



	public MensajeTransaccionBean altaPlantilla(final DetallePolizaBean poliza, final String consecutivo) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{

			String query = "call DETALLEPOLPLANALT(?,?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?);";
			Object[] parametros = {
					parametrosAuditoriaBean.getEmpresaID(),
					consecutivo,//poliza.getPolizaID(),
					poliza.getFecha(),
					poliza.getCentroCostoID(),
					poliza.getCuentaCompleta(),
					poliza.getInstrumento(),
					poliza.getMonedaID(),
					poliza.getCargos(),
					poliza.getAbonos(),
					poliza.getDescripcion(),
					poliza.getReferencia(),
					"DETALLEPOLIZAALT",//poliza.getProcedimientoCont(),

					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"DetallePolPlanDAO.alta",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEPOLPLANALT(" + Arrays.toString(parametros) + ")");

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
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de plan de poliza", e);
		}
		return mensaje;
	}





	public MensajeTransaccionBean bajaDetallePolizaPlantilla(final PolizaBean poliza) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			//Query cons el Store Procedure
			String query = "call DETALLEPOLPLANBAJ(?, ?,?,?,?,?,?);";
			Object[] parametros = {
					poliza.getPolizaID(),

					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"DetallePolizaDAO.bajaDetallePoliza",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEPOLPLANBAJ(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					mensaje.setConsecutivoString(resultSet.getString(4));
					return mensaje;

				}
			});
			return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
		} catch (Exception e) {

			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de plan de poliza", e);
		}
		return mensaje;
	}

	public List lista(DetallePolizaBean poliza, int tipoLista){


		String query = "call DETALLEPOLIZALIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								poliza.getPolizaID(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DetallePolizaDAO.lista",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEPOLIZALIS(" + Arrays.toString(parametros) + ")");

        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				DetallePolizaBean poliza = new DetallePolizaBean();
				poliza.setPolizaID(resultSet.getString(1));
				poliza.setCentroCostoID(resultSet.getString(2));
				poliza.setCuentaCompleta(resultSet.getString(3));
				poliza.setReferencia(resultSet.getString(4));
				poliza.setDescripcion(resultSet.getString(5));
				poliza.setRFC(resultSet.getString(6));
				poliza.setTotalFactura(resultSet.getString(7));
				poliza.setFolioUUID(resultSet.getString(8));
				poliza.setCargos(resultSet.getString(9));
				poliza.setAbonos(resultSet.getString(10));
				return poliza;
			}
		});
		return matches;
	}


	public List listaDetallePolPla(DetallePolizaBean detallePolPlan, int tipoLista) {
		String query = "call DETALLEPOLPLANLIS(?,?, ?,?,?,?,?,?);";
		Object[] parametros = {
				               detallePolPlan.getPolizaID(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DetallePolizaDAO.listaDetallePolPla",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEPOLPLANLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				DetallePolizaBean detallePolPlan = new DetallePolizaBean();
				detallePolPlan.setPolizaID(resultSet.getString(1));
				detallePolPlan.setCentroCostoID(resultSet.getString(2));
				detallePolPlan.setCuentaCompleta(resultSet.getString(3));
				detallePolPlan.setReferencia(resultSet.getString(4));
				detallePolPlan.setDescripcion(resultSet.getString(5));
				detallePolPlan.setCargos(resultSet.getString(6));
				detallePolPlan.setAbonos(resultSet.getString(7));
				return detallePolPlan;
			}
		});
		return matches;
	}
	public List listaCePolizasXml(CePolizasBean polizasBean) {
		String query = "call CEPOLIZASLIS(?,?,?,?,?   ,?,?,?);";
		Object[] parametros = {
				               polizasBean.getFecha(),

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DetallePolizaDAO.listaCePolizasXml",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEPOLIZASLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CePolizasBean polizasBean = new CePolizasBean();
				polizasBean.setPolizaID(resultSet.getString(1));
				polizasBean.setConsecutivo(resultSet.getString(2));
				polizasBean.setFecha(resultSet.getString(3));
				polizasBean.setConceptoPoliza(resultSet.getString(4));
				polizasBean.setTipo(resultSet.getString(5));
				polizasBean.setCuentaCompleta(resultSet.getString(6));
				polizasBean.setConceptoDetalle(resultSet.getString(7));
				polizasBean.setDebe(resultSet.getString(8));
				polizasBean.setHaber(resultSet.getString(9));
				polizasBean.setMoneda(resultSet.getString(10));
				polizasBean.setFolioUUID(resultSet.getString(11));
				polizasBean.setTotalFactura(resultSet.getString(12));
				polizasBean.setRfc(resultSet.getString(13));
				polizasBean.setDesCorta(resultSet.getString(14));
				return polizasBean;
			}
		});
		return matches;
	}

	public List listaCeAuxiliarCuentasXml(CePolizasBean polizasBean) {
		String query = "call AUXILIARCUENTASREP(?,?,?,?,?   ,?,?,?);";
		Object[] parametros = {
				               polizasBean.getFecha(),

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DetallePolizaDAO.listaCePolizasXml",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AUXILIARCUENTASREP(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CePolizasBean polizasBean = new CePolizasBean();
				polizasBean.setConsecutivo(resultSet.getString("Consecutivo"));
				polizasBean.setCuentaCompleta(resultSet.getString("CuentaCompleta"));
				polizasBean.setDescripcionCuenta(resultSet.getString("DescripcionCuenta"));
				polizasBean.setSaldoInicial(resultSet.getString("SaldoInicial"));
				polizasBean.setSaldoFinal(resultSet.getString("SaldoFinal"));
				polizasBean.setFecha(resultSet.getString("Fecha"));
				polizasBean.setPolizaID(resultSet.getString("PolizaID"));
				polizasBean.setConceptoDetalle(resultSet.getString("Concepto"));
				polizasBean.setDebe(resultSet.getString("Debe"));
				polizasBean.setHaber(resultSet.getString("Haber"));



				return polizasBean;
			}
		});
		return matches;
	}

	public List listaCeAuxiliarFoliosXml(CePolizasBean polizasBean) {
		String query = "call AUXILIARFOLIOSREP(?,?,?,?,?   ,?,?,?);";
		Object[] parametros = {
				               polizasBean.getFecha(),

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DetallePolizaDAO.listaCePolizasXml",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AUXILIARFOLIOSLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CePolizasBean polizasBean = new CePolizasBean();
				polizasBean.setConsecutivo(resultSet.getString("Consecutivo"));
				polizasBean.setPolizaID(resultSet.getString("PolizaID"));
				polizasBean.setFecha(resultSet.getString("Fecha"));
				polizasBean.setFolioUUID(resultSet.getString("FolioUUID"));
				polizasBean.setRfc(resultSet.getString("RFC"));
				polizasBean.setMetodoPago(resultSet.getString("MetodoPago"));
				polizasBean.setTotalFactura(resultSet.getString("MontoTotal"));
				polizasBean.setMoneda(resultSet.getString("Moneda"));
				polizasBean.setTipoCambio(resultSet.getString("TipoCambio"));


				return polizasBean;
			}
		});
		return matches;
	}

}
