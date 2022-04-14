package cedes.dao;

import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.TipoInversionBean;

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

import cedes.bean.TiposCedesBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;

public class TiposCedesDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";


	public MensajeTransaccionBean alta(final TiposCedesBean tiposCedesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		String cadena = "";
		if( tiposCedesBean.getLactividadBMXID() != null ){
			List<String> listaActividades = tiposCedesBean.getLactividadBMXID();
				if(!listaActividades.isEmpty()){
						if (listaActividades.size() > 0){
							for(String actividad:listaActividades){
								cadena += actividad+",";
							}
							tiposCedesBean.setActividadBMX(cadena.substring(0, cadena.length()-1));
						}
				}
			}
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TIPOSCEDESALT(?,?,?,?,?,  	?,?,?,?,?,"
																	+ "?,?,?,?,?, 	?,?,?,?,?, "
																	+ "?,?,?,?,?,		?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Descripcion", tiposCedesBean.getDescripcion());
									sentenciaStore.setString("Par_FechaCreacion",Utileria.convierteFecha(tiposCedesBean.getFechaCreacion()));
									sentenciaStore.setString("Par_TasaFV",tiposCedesBean.getTasaFV());
									sentenciaStore.setString("Par_Anclaje",tiposCedesBean.getAnclaje());
									sentenciaStore.setString("Par_TasaMejorada",tiposCedesBean.getTasaMejorada());

									sentenciaStore.setString("Par_EspecificaTasa",tiposCedesBean.getEspecificaTasa());
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(tiposCedesBean.getMonedaId()));
									sentenciaStore.setDouble("Par_MinimoApertura",Utileria.convierteDoble(tiposCedesBean.getMinimoApertura()));
									sentenciaStore.setDouble("Par_MinimoAnclaje",Utileria.convierteDoble(tiposCedesBean.getMinimoAnclaje()));
									sentenciaStore.setString("Par_Genero",tiposCedesBean.getGenero());

									sentenciaStore.setString("Par_EstadoCivil",tiposCedesBean.getEstadoCivil());
									sentenciaStore.setInt("Par_MinimoEdad",Utileria.convierteEntero(tiposCedesBean.getMinimoEdad()));
									sentenciaStore.setInt("Par_MaximoEdad",Utileria.convierteEntero(tiposCedesBean.getMaximoEdad()));
									sentenciaStore.setString("Par_ActividadEcon",tiposCedesBean.getActividadBMX());
									sentenciaStore.setString("Par_NumRegistroRECA", tiposCedesBean.getNumRegistroRECA());

									sentenciaStore.setString("Par_FechaInscripcion",Utileria.convierteFecha(tiposCedesBean.getFechaInscripcion()));
									sentenciaStore.setString("Par_NombreComercial", tiposCedesBean.getNombreComercial());
									sentenciaStore.setString("Par_Reinversion", tiposCedesBean.getReinversion());
									sentenciaStore.setString("Par_Reinvertir", tiposCedesBean.getReinvertir());
									sentenciaStore.setString("Par_DiaInhabil", tiposCedesBean.getDiaInhabil());

									sentenciaStore.setString("Par_TipoPagoInt", tiposCedesBean.getTipoPagoInt());
									sentenciaStore.setString("Par_DiasPeriodo", tiposCedesBean.getDiasPeriodo());
									sentenciaStore.setString("Par_PagoIntCal", tiposCedesBean.getPagoIntCal());
									sentenciaStore.setString("Par_ClaveCNBV",tiposCedesBean.getClaveCNBV());
									sentenciaStore.setString("Par_ClaveCNBVAmpCred",tiposCedesBean.getClaveCNBVAmpCred());

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TipoCedesDAO.alta");
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
							throw new Exception(Constantes.MSG_ERROR + " .TipoCedesDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Tipo de CEDES" + e);
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


	public MensajeTransaccionBean modifica(final TiposCedesBean tiposCedesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		String cadena = "";
		if( tiposCedesBean.getLactividadBMXID() != null ){
			List<String> listaActividades = tiposCedesBean.getLactividadBMXID();
				if(!listaActividades.isEmpty()){
						if (listaActividades.size() > 0){
							for(String actividad:listaActividades){
								cadena += actividad+",";
							}
							tiposCedesBean.setActividadBMX(cadena.substring(0, cadena.length()-1));
						}
				}
			}
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TIPOSCEDESMOD(?,?,?,?,?,	?,?,?,?,?,"
																	+ "?,?,?,?,?,	?,?,?,?,?,?,"
																	+ "?,?,?,?,?,		?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_TipoCedeID", tiposCedesBean.getTipoCedeID());
									sentenciaStore.setString("Par_Descripcion", tiposCedesBean.getDescripcion());
									sentenciaStore.setString("Par_FechaCreacion", tiposCedesBean.getFechaCreacion());
									sentenciaStore.setString("Par_TasaFV",tiposCedesBean.getTasaFV());
									sentenciaStore.setString("Par_Anclaje",tiposCedesBean.getAnclaje());

									sentenciaStore.setString("Par_TasaMejorada",tiposCedesBean.getTasaMejorada());
									sentenciaStore.setString("Par_EspecificaTasa",tiposCedesBean.getEspecificaTasa());
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(tiposCedesBean.getMonedaId()));
									sentenciaStore.setDouble("Par_MinimoApertura",Utileria.convierteDoble(tiposCedesBean.getMinimoApertura()));
									sentenciaStore.setDouble("Par_MinimoAnclaje",Utileria.convierteDoble(tiposCedesBean.getMinimoAnclaje()));

									sentenciaStore.setString("Par_Genero",tiposCedesBean.getGenero());
									sentenciaStore.setString("Par_EstadoCivil",tiposCedesBean.getEstadoCivil());
									sentenciaStore.setInt("Par_MinimoEdad",Utileria.convierteEntero(tiposCedesBean.getMinimoEdad()));
									sentenciaStore.setInt("Par_MaximoEdad",Utileria.convierteEntero(tiposCedesBean.getMaximoEdad()));
									sentenciaStore.setString("Par_ActividadEcon",tiposCedesBean.getActividadBMX());

									sentenciaStore.setString("Par_NumRegistroRECA", tiposCedesBean.getNumRegistroRECA());
									sentenciaStore.setString("Par_FechaInscripcion",Utileria.convierteFecha(tiposCedesBean.getFechaInscripcion()));
									sentenciaStore.setString("Par_NombreComercial", tiposCedesBean.getNombreComercial());
									sentenciaStore.setString("Par_Reinversion", tiposCedesBean.getReinversion());
									sentenciaStore.setString("Par_Reinvertir", tiposCedesBean.getReinvertir());

									sentenciaStore.setString("Par_DiaInhabil", tiposCedesBean.getDiaInhabil());
									sentenciaStore.setString("Par_TipoPagoInt", tiposCedesBean.getTipoPagoInt());
									sentenciaStore.setString("Par_DiasPeriodo", tiposCedesBean.getDiasPeriodo());
									sentenciaStore.setString("Par_PagoIntCal", tiposCedesBean.getPagoIntCal());
									sentenciaStore.setString("Par_ClaveCNBV",tiposCedesBean.getClaveCNBV());
									sentenciaStore.setString("Par_ClaveCNBVAmpCred",tiposCedesBean.getClaveCNBVAmpCred());

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TipoCedesDAO.modifica");
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
							throw new Exception(Constantes.MSG_ERROR + " .TipoCedesDAO.modifica");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Modificación de Tipo de CEDES" + e);
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

	public TiposCedesBean consultaPrincipal(TiposCedesBean tiposCedesBean, int tipoConsulta){
		String query = "call TIPOSCEDESCON(?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {	Integer.parseInt(tiposCedesBean.getTipoCedeID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoCedesDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSCEDESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TiposCedesBean tiposCedes = new TiposCedesBean();

				tiposCedes.setTipoCedeID(Utileria.completaCerosIzquierda(String.valueOf(resultSet.getInt("TipoCedeID")), 5));
				tiposCedes.setDescripcion(resultSet.getString("Descripcion"));
				tiposCedes.setFechaCreacion(resultSet.getString("FechaCreacion"));
				tiposCedes.setTasaFV(resultSet.getString("TasaFV"));
				tiposCedes.setAnclaje(resultSet.getString("Anclaje"));
				tiposCedes.setTasaMejorada(resultSet.getString("TasaMejorada"));
				tiposCedes.setEspecificaTasa(resultSet.getString("EspecificaTasa"));
				tiposCedes.setMonedaID(resultSet.getString("MonedaID"));
				tiposCedes.setDescripcionMon(resultSet.getString("DescripcionMon"));
				tiposCedes.setDiaInhabil(resultSet.getString("DiaInhabil"));
				tiposCedes.setMinimoAnclaje(resultSet.getString("MontoMinAnclaje"));
				tiposCedes.setEstatus(resultSet.getString("Estatus"));

				return tiposCedes;
			}
		});

		return matches.size() > 0 ? (TiposCedesBean) matches.get(0) : null;

	}

	public TiposCedesBean consultaGeneral(TiposCedesBean tiposCedesBean, int tipoConsulta){
		String query = "call TIPOSCEDESCON(?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {	Integer.parseInt(tiposCedesBean.getTipoCedeID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoCedesDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSCEDESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TiposCedesBean tiposCedes = new TiposCedesBean();

				tiposCedes.setTipoCedeID(resultSet.getString("TipoCedeID"));
				tiposCedes.setDescripcion(resultSet.getString("Descripcion"));
				tiposCedes.setFechaCreacion(resultSet.getString("FechaCreacion"));
				tiposCedes.setTasaFV(resultSet.getString("TasaFV"));
				tiposCedes.setAnclaje(resultSet.getString("Anclaje"));
				tiposCedes.setTasaMejorada(resultSet.getString("TasaMejorada"));
				tiposCedes.setEspecificaTasa(resultSet.getString("EspecificaTasa"));
				tiposCedes.setMonedaId(resultSet.getString("MonedaID"));
				tiposCedes.setMinimoApertura(resultSet.getString("MinimoApertura"));
				tiposCedes.setMinimoAnclaje(resultSet.getString("MontoMinimoAnclaje"));
				tiposCedes.setGenero(resultSet.getString("Genero"));
				tiposCedes.setEstadoCivil(resultSet.getString("EstadoCivil"));
				tiposCedes.setMinimoEdad(resultSet.getString("MinimoEdad"));
				tiposCedes.setMaximoEdad(resultSet.getString("MaximoEdad"));
				tiposCedes.setActividadBMX(resultSet.getString("ActividadEcon"));
				tiposCedes.setNumRegistroRECA(resultSet.getString("NumRegistroRECA"));
				tiposCedes.setFechaInscripcion(resultSet.getString("FechaInscripcion"));
				tiposCedes.setNombreComercial(resultSet.getString("NombreComercial"));
				tiposCedes.setReinversion(resultSet.getString("Reinversion"));
				tiposCedes.setReinvertir(resultSet.getString("Reinvertir"));
				tiposCedes.setDiaInhabil(resultSet.getString("DiaInhabil"));
				tiposCedes.setTipoPagoInt(resultSet.getString("TipoPagoInt"));
				tiposCedes.setDiasPeriodo(resultSet.getString("DiasPeriodo"));
				tiposCedes.setPagoIntCal(resultSet.getString("PagoIntCal"));
				tiposCedes.setClaveCNBV(resultSet.getString("ClaveCNBV"));
				tiposCedes.setClaveCNBVAmpCred(resultSet.getString("ClaveCNBVAmpCred"));
				tiposCedes.setEstatus(resultSet.getString("Estatus"));


				return tiposCedes;
			}
		});

		return matches.size() > 0 ? (TiposCedesBean) matches.get(0) : null;

	}



	/* Lista principal de CEDES */
	public List listaPrincipal(TiposCedesBean tiposCedesBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSCEDESLIS(?,?,?,?,?,  ?,?,?,?);";
		Object[] parametros = {	tiposCedesBean.getDescripcion(),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSCEDESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposCedesBean tiposCedesBean = new TiposCedesBean();
				tiposCedesBean.setTipoCedeID(resultSet.getString("TipoCedeID"));
				tiposCedesBean.setDescripcion(resultSet.getString("Descripcion"));
				return tiposCedesBean;
			}
		});
		return matches;
	}

	public TiposCedesDAO (){
		super();
	}

	public List listaCedes(int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSCEDESLIS(?,?,?,?,?,	?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								tipoLista,
				                Constantes.ENTERO_CERO,
				                Constantes.ENTERO_CERO,
				                Constantes.FECHA_VACIA,

				                Constantes.STRING_VACIO,
				                "TiposCedesDAO.listaCedes",
				                Constantes.ENTERO_CERO,
				                Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSCEDESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposCedesBean tiposCedesBean = new TiposCedesBean();
				tiposCedesBean.setTipoCedeID(String.valueOf(resultSet.getInt("TipoCedeID")));
				tiposCedesBean.setDescripcion(resultSet.getString("Descripcion"));
				return tiposCedesBean;
			}
		});

		return matches;
	}

}

