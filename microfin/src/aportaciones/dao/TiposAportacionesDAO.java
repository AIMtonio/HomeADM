package aportaciones.dao;

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

import aportaciones.bean.TiposAportacionesBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;

public class TiposAportacionesDAO extends BaseDAO {

	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";

	public TiposAportacionesDAO (){
		super();
	}


	// METOD PARA DAR DE ALTA EL TIPO DE APORTACION
	public MensajeTransaccionBean alta(final TiposAportacionesBean tiposAportacionesBean) {
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
									String query = "call TIPOSAPORTACIONESALT(?,?,?,?,?,  	?,?,?,?,?,"
																			+ "?,?,?,?,?, 	?,?,?,?,?, "
																			+ "?,?,?,?,?,	?,?,?,?,?,	"
																			+ "?,?,?,?,?,	?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Descripcion", tiposAportacionesBean.getDescripcion());
									sentenciaStore.setString("Par_FechaCreacion",Utileria.convierteFecha(tiposAportacionesBean.getFechaCreacion()));
									sentenciaStore.setString("Par_TasaFV",tiposAportacionesBean.getTasaFV());
									sentenciaStore.setString("Par_Anclaje",tiposAportacionesBean.getAnclaje());
									sentenciaStore.setString("Par_TasaMejorada",tiposAportacionesBean.getTasaMejorada());

									sentenciaStore.setString("Par_EspecificaTasa",tiposAportacionesBean.getEspecificaTasa());
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(tiposAportacionesBean.getMonedaId()));
									sentenciaStore.setDouble("Par_MinimoApertura",Utileria.convierteDoble(tiposAportacionesBean.getMinimoApertura()));
									sentenciaStore.setDouble("Par_MinimoAnclaje",Utileria.convierteDoble(tiposAportacionesBean.getMinimoAnclaje()));
									sentenciaStore.setString("Par_NumRegistroRECA", tiposAportacionesBean.getNumRegistroRECA());

									sentenciaStore.setString("Par_FechaInscripcion",Utileria.convierteFecha(tiposAportacionesBean.getFechaInscripcion()));
									sentenciaStore.setString("Par_NombreComercial", tiposAportacionesBean.getNombreComercial());
									sentenciaStore.setString("Par_Reinversion", tiposAportacionesBean.getReinversion());
									sentenciaStore.setString("Par_Reinvertir", tiposAportacionesBean.getReinvertir());
									sentenciaStore.setString("Par_DiaInhabil", tiposAportacionesBean.getDiaInhabil());

									sentenciaStore.setString("Par_TipoPagoInt", tiposAportacionesBean.getTipoPagoInt());
									sentenciaStore.setString("Par_DiasPeriodo", tiposAportacionesBean.getDiasPeriodo());
									sentenciaStore.setString("Par_PagoIntCal", tiposAportacionesBean.getPagoIntCal());
									sentenciaStore.setString("Par_ClaveCNBV",tiposAportacionesBean.getClaveCNBV());
									sentenciaStore.setString("Par_ClaveCNBVAmpCred",tiposAportacionesBean.getClaveCNBVAmpCred());

									sentenciaStore.setDouble("Par_MaxPuntos",Utileria.convierteDoble(tiposAportacionesBean.getMaxPuntos()));
									sentenciaStore.setDouble("Par_MinPuntos",Utileria.convierteDoble(tiposAportacionesBean.getMinPuntos()));
									sentenciaStore.setString("Par_TasaMontoGlobal", tiposAportacionesBean.getTasaMontoGlobal());
									sentenciaStore.setString("Par_IncluyeGpoFam", tiposAportacionesBean.getIncluyeGpoFam());
									sentenciaStore.setString("Par_DiasPago", tiposAportacionesBean.getDiasPago());

									sentenciaStore.setString("Par_PagoIntCapitaliza", tiposAportacionesBean.getPagoIntCapitaliza());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TipoAportacionesDAO.alta");
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
							throw new Exception(Constantes.MSG_ERROR + " .TipoAportacionesDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Tipo de Aportación" + e);
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


	//METODO PARA MODIFICAR LOS TIPOS DE APORTACIONES
	public MensajeTransaccionBean modifica(final TiposAportacionesBean tiposAportacionesBean) {
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
									String query = "call TIPOSAPORTACIONESMOD(?,?,?,?,?,	?,?,?,?,?,"
																			+ "?,?,?,?,?,	?,?,?,?,?,"
																			+ "?,?,?,?,?,	?,?,?,?,?,"
																			+ "?,?,?,?,?,	?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_TipoAportacionID", tiposAportacionesBean.getTipoAportacionID());
									sentenciaStore.setString("Par_Descripcion", tiposAportacionesBean.getDescripcion());
									sentenciaStore.setString("Par_FechaCreacion", tiposAportacionesBean.getFechaCreacion());
									sentenciaStore.setString("Par_TasaFV",tiposAportacionesBean.getTasaFV());
									sentenciaStore.setString("Par_Anclaje",tiposAportacionesBean.getAnclaje());

									sentenciaStore.setString("Par_TasaMejorada",tiposAportacionesBean.getTasaMejorada());
									sentenciaStore.setString("Par_EspecificaTasa",tiposAportacionesBean.getEspecificaTasa());
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(tiposAportacionesBean.getMonedaId()));
									sentenciaStore.setDouble("Par_MinimoApertura",Utileria.convierteDoble(tiposAportacionesBean.getMinimoApertura()));
									sentenciaStore.setDouble("Par_MinimoAnclaje",Utileria.convierteDoble(tiposAportacionesBean.getMinimoAnclaje()));

									sentenciaStore.setString("Par_NumRegistroRECA", tiposAportacionesBean.getNumRegistroRECA());
									sentenciaStore.setString("Par_FechaInscripcion",Utileria.convierteFecha(tiposAportacionesBean.getFechaInscripcion()));
									sentenciaStore.setString("Par_NombreComercial", tiposAportacionesBean.getNombreComercial());
									sentenciaStore.setString("Par_Reinversion", tiposAportacionesBean.getReinversion());
									sentenciaStore.setString("Par_Reinvertir", tiposAportacionesBean.getReinvertir());

									sentenciaStore.setString("Par_DiaInhabil", tiposAportacionesBean.getDiaInhabil());
									sentenciaStore.setString("Par_TipoPagoInt", tiposAportacionesBean.getTipoPagoInt());
									sentenciaStore.setString("Par_DiasPeriodo", tiposAportacionesBean.getDiasPeriodo());
									sentenciaStore.setString("Par_PagoIntCal", tiposAportacionesBean.getPagoIntCal());
									sentenciaStore.setString("Par_ClaveCNBV",tiposAportacionesBean.getClaveCNBV());

									sentenciaStore.setString("Par_ClaveCNBVAmpCred",tiposAportacionesBean.getClaveCNBVAmpCred());
									sentenciaStore.setDouble("Par_MaxPuntos",Utileria.convierteDoble(tiposAportacionesBean.getMaxPuntos()));
									sentenciaStore.setDouble("Par_MinPuntos",Utileria.convierteDoble(tiposAportacionesBean.getMinPuntos()));
									sentenciaStore.setString("Par_TasaMontoGlobal", tiposAportacionesBean.getTasaMontoGlobal());
									sentenciaStore.setString("Par_IncluyeGpoFam", tiposAportacionesBean.getIncluyeGpoFam());
									sentenciaStore.setString("Par_DiasPago", tiposAportacionesBean.getDiasPago());

									sentenciaStore.setString("Par_PagoIntCapitaliza", tiposAportacionesBean.getPagoIntCapitaliza());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TipoAportacionesDAO.modifica");
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
							throw new Exception(Constantes.MSG_ERROR + " .TipoAportacionesDAO.modifica");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Modificación de Tipo de Aportación" + e);
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

	//METODO PARA REALIZAR CONSULTA PRINCIPAL DE APORTACIONES
	public TiposAportacionesBean consultaPrincipal(TiposAportacionesBean tiposAportacionesBean, int tipoConsulta){
		String query = "call TIPOSAPORTACIONESCON(?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {	Integer.parseInt(tiposAportacionesBean.getTipoAportacionID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoAportacionesDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSAPORTACIONESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TiposAportacionesBean tiposAportaciones = new TiposAportacionesBean();

				tiposAportaciones.setTipoAportacionID(Utileria.completaCerosIzquierda(String.valueOf(resultSet.getInt("TipoAportacionID")), 5));
				tiposAportaciones.setDescripcion(resultSet.getString("Descripcion"));
				tiposAportaciones.setFechaCreacion(resultSet.getString("FechaCreacion"));
				tiposAportaciones.setTasaFV(resultSet.getString("TasaFV"));
				tiposAportaciones.setAnclaje(resultSet.getString("Anclaje"));
				tiposAportaciones.setTasaMejorada(resultSet.getString("TasaMejorada"));
				tiposAportaciones.setEspecificaTasa(resultSet.getString("EspecificaTasa"));
				tiposAportaciones.setMonedaID(resultSet.getString("MonedaID"));
				tiposAportaciones.setDescripcionMon(resultSet.getString("DescripcionMon"));
				tiposAportaciones.setDiaInhabil(resultSet.getString("DiaInhabil"));
				tiposAportaciones.setMinimoAnclaje(resultSet.getString("MontoMinAnclaje"));

				return tiposAportaciones;
			}
		});

		return matches.size() > 0 ? (TiposAportacionesBean) matches.get(0) : null;

	}


	// METODO PARA REALIZAR LA CONSULTA GENERAL DEL TIPO DE APORTACION
	public TiposAportacionesBean consultaGeneral(TiposAportacionesBean tiposAportacionesBean, int tipoConsulta){
		String query = "call TIPOSAPORTACIONESCON(?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {	Integer.parseInt(tiposAportacionesBean.getTipoAportacionID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoAportacionesDAO.consultaGeneral",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSAPORTACIONESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TiposAportacionesBean tiposAportaciones = new TiposAportacionesBean();

				tiposAportaciones.setTipoAportacionID(resultSet.getString("TipoAportacionID"));
				tiposAportaciones.setDescripcion(resultSet.getString("Descripcion"));
				tiposAportaciones.setFechaCreacion(resultSet.getString("FechaCreacion"));
				tiposAportaciones.setTasaFV(resultSet.getString("TasaFV"));
				tiposAportaciones.setAnclaje(resultSet.getString("Anclaje"));
				tiposAportaciones.setTasaMejorada(resultSet.getString("TasaMejorada"));
				tiposAportaciones.setEspecificaTasa(resultSet.getString("EspecificaTasa"));
				tiposAportaciones.setMonedaId(resultSet.getString("MonedaID"));
				tiposAportaciones.setMinimoApertura(resultSet.getString("MinimoApertura"));
				tiposAportaciones.setMinimoAnclaje(resultSet.getString("MontoMinimoAnclaje"));
				tiposAportaciones.setNumRegistroRECA(resultSet.getString("NumRegistroRECA"));
				tiposAportaciones.setFechaInscripcion(resultSet.getString("FechaInscripcion"));
				tiposAportaciones.setNombreComercial(resultSet.getString("NombreComercial"));
				tiposAportaciones.setReinversion(resultSet.getString("Reinversion"));
				tiposAportaciones.setReinvertir(resultSet.getString("Reinvertir"));
				tiposAportaciones.setDiaInhabil(resultSet.getString("DiaInhabil"));
				tiposAportaciones.setTipoPagoInt(resultSet.getString("TipoPagoInt"));
				tiposAportaciones.setDiasPeriodo(resultSet.getString("DiasPeriodo"));
				tiposAportaciones.setPagoIntCal(resultSet.getString("PagoIntCal"));
				tiposAportaciones.setClaveCNBV(resultSet.getString("ClaveCNBV"));
				tiposAportaciones.setClaveCNBVAmpCred(resultSet.getString("ClaveCNBVAmpCred"));
				tiposAportaciones.setMaxPuntos(resultSet.getString("MaxPuntos"));
				tiposAportaciones.setMinPuntos(resultSet.getString("MinPuntos"));
				tiposAportaciones.setTasaMontoGlobal(resultSet.getString("TasaMontoGlobal"));
				tiposAportaciones.setIncluyeGpoFam(resultSet.getString("IncluyeGpoFam"));
				tiposAportaciones.setDiasPago(resultSet.getString("DiasPago"));
				tiposAportaciones.setPagoIntCapitaliza(resultSet.getString("PagoIntCapitaliza"));

				return tiposAportaciones;
			}
		});

		return matches.size() > 0 ? (TiposAportacionesBean) matches.get(0) : null;

	}

	// LISTA PRINCIPAL DE APORTACIONES
	public List listaPrincipal(TiposAportacionesBean tiposAportacionesBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSAPORTACIONESLIS(?,?,?,?,?,  ?,?,?,?);";
		Object[] parametros = {	tiposAportacionesBean.getDescripcion(),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSAPORTACIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposAportacionesBean tiposAportaciones = new TiposAportacionesBean();
				tiposAportaciones.setTipoAportacionID(resultSet.getString("TipoAportacionID"));
				tiposAportaciones.setDescripcion(resultSet.getString("Descripcion"));
				return tiposAportaciones;
			}
		});
		return matches;
	}


	// LISTA DE APORTACIONES
	public List listaAportaciones(int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSAPORTACIONESLIS(?,?,?,?,?,	?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								tipoLista,
				                Constantes.ENTERO_CERO,
				                Constantes.ENTERO_CERO,
				                Constantes.FECHA_VACIA,

				                Constantes.STRING_VACIO,
				                "TiposAportacionesDAO.listaAportaciones",
				                Constantes.ENTERO_CERO,
				                Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSAPORTACIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposAportacionesBean tiposAportaciones = new TiposAportacionesBean();
				tiposAportaciones.setTipoAportacionID(String.valueOf(resultSet.getInt("TipoAportacionID")));
				tiposAportaciones.setDescripcion(resultSet.getString("Descripcion"));
				return tiposAportaciones;
			}
		});

		return matches;
	}
}
