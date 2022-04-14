package soporte.dao;
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

import soporte.bean.InstitucionesBean;
import tesoreria.bean.AlgoritmoDepRefBean;

public class InstitucionesDAO extends BaseDAO{

	InstitucionesDAO(){
		super();
	}

	//------------Transaccciones------------------------------------------------//
	//-----Alta de instituciones------------
	public MensajeTransaccionBean altaInstitucion(final InstitucionesBean institucion) {

		return null;
	}

	//------Modificacion de institucions---------

	public MensajeTransaccionBean modificaInstitucion(final InstitucionesBean institucion){
		return null;
	}

	//  ACTUALIZA SI GENERA DEPOSITOS REFERENCIADOS
	public MensajeTransaccionBean actualizarInstitucion(final int tipoTransaccion,final InstitucionesBean institucion){
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

									String query = "call INSTITUCIONESACT(" +
										"?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(institucion.getInstitucionID()));
									sentenciaStore.setString("Par_GeneraRefeDep", institucion.getGeneraRefeDep());
									sentenciaStore.setInt("Par_AlgoritmoID", Utileria.convierteEntero(institucion.getAlgoritmoID()));
									sentenciaStore.setString("Par_NumConvenio",institucion.getNumConvenio());
									sentenciaStore.setString("Par_ConvenioInter", institucion.getConvenioInter());
									sentenciaStore.setString("Par_Domicilia", institucion.getDomicilia());
									sentenciaStore.setString("Par_NumContrato", institucion.getNumContrato());
									sentenciaStore.setString("Par_CveEmision", institucion.getCveEmision());

									sentenciaStore.setInt("Par_NumAct", tipoTransaccion);

									sentenciaStore.setString("Par_Salida","S");
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","microfin/paramDepRefInstituciones.htm");
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InstitucionesDAO.actualizarInstitucion");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .InstitucionesDAO.actualizarInstitucion");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Actualizacion de Institucion" + e);
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

	public InstitucionesBean consultaPrincipal(InstitucionesBean institucion, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call INSTITUCIONESCON(?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {	Utileria.convierteEntero(institucion.getInstitucionID()),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"InstitucionesDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITUCIONESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InstitucionesBean institucionesBean = new InstitucionesBean();

				institucionesBean.setInstitucionID(resultSet.getString("InstitucionID"));
				institucionesBean.setEmpresaID(resultSet.getString("EmpresaID"));
				institucionesBean.setNombre(resultSet.getString("Nombre"));
				institucionesBean.setNombreCorto(resultSet.getString("NombreCorto"));
				institucionesBean.setTipoInstitID(resultSet.getString("TipoInstitID"));

				institucionesBean.setFolio(resultSet.getString("Folio"));
				institucionesBean.setClaveParticipaSpei(resultSet.getString("ClaveParticipaSpei"));
				institucionesBean.setDireccion(resultSet.getString("Direccion"));
				institucionesBean.setGeneraRefeDep(resultSet.getString("GeneraRefeDep"));
				institucionesBean.setAlgoritmoID(resultSet.getString("AlgoritmoID"));
				institucionesBean.setNumConvenio(resultSet.getString("NumConvenio"));
				institucionesBean.setConvenioInter(resultSet.getString("ConvenioInter"));
				institucionesBean.setDomicilia(resultSet.getString("Domicilia"));
				institucionesBean.setNumContrato(resultSet.getString("NumContrato"));
				institucionesBean.setCveEmision(resultSet.getString("CveEmision"));

				return institucionesBean;

			}
		});

		return matches.size() > 0 ? (InstitucionesBean) matches.get(0) : null;
	}


	/* Consuta institucion foranea*/
	public InstitucionesBean consultaForanea(InstitucionesBean instituciones, int tipoConsulta) {

		String query = "call INSTITUCIONESCON(?,?, ?,?,?,?,?,?,?);";

				Object[] parametros = {	Utileria.convierteEntero(instituciones.getInstitucionID()),
										tipoConsulta,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"InstitucionesDAO.consultaForanea",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITUCIONESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InstitucionesBean institucionesBean = new InstitucionesBean();
				institucionesBean.setInstitucionID(resultSet.getString(1));
				institucionesBean.setEmpresaID(resultSet.getString(2));
				institucionesBean.setNombre(resultSet.getString(3)+" ( "+resultSet.getString(4)+" )");
				institucionesBean.setNombreCorto(resultSet.getString(4));
					return institucionesBean;

			}
		});

		return matches.size() > 0 ? (InstitucionesBean) matches.get(0) : null;
	}


	public InstitucionesBean consultaFolio(InstitucionesBean institucionesBean, int tipoConsulta){
		String query = "call INSTITUCIONESCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(institucionesBean.getInstitucionID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"OperDispersionDao.consultaFolio",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITUCIONESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InstitucionesBean instituciones = new InstitucionesBean();
				instituciones.setFolio(resultSet.getString(1));
				return instituciones;
			}
		});
		return matches.size() > 0 ? (InstitucionesBean) matches.get(0) : null;
	}

	public InstitucionesBean consultaClaveSpei(InstitucionesBean instituciones, int tipoConsulta) {

		String query = "call INSTITUCIONESCON(?,?, ?,?,?,?,?,?,?);";

				Object[] parametros = {	Utileria.convierteEntero(instituciones.getInstitucionID()),
										tipoConsulta,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"InstitucionesDAO.consultaForanea",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITUCIONESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InstitucionesBean institucionesBean = new InstitucionesBean();
				institucionesBean.setInstitucionID(resultSet.getString("InstitucionID"));
				institucionesBean.setClaveParticipaSpei(resultSet.getString("ClaveParticipaSpei"));
				institucionesBean.setEmpresaID(resultSet.getString("EmpresaID"));
				institucionesBean.setNombre(resultSet.getString("Nombre")+" ( "+resultSet.getString("Nombre")+" )");
				institucionesBean.setNombreCorto(resultSet.getString("NombreCorto"));
				institucionesBean.setDomicilia(resultSet.getString("Domicilia"));
					return institucionesBean;

			}
		});

		return matches.size() > 0 ? (InstitucionesBean) matches.get(0) : null;
	}



	public List listaInstitucion(InstitucionesBean institucion, int tipoLista){
		String query = "call INSTITUCIONESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	institucion.getNombre() != null ? institucion.getNombre() : institucion.getInstitucionID(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"InstitucionesDAO.listaInstitucion",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITUCIONESLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				InstitucionesBean institucion = new InstitucionesBean();
				institucion.setInstitucionID(String.valueOf(resultSet.getInt(1)));
				institucion.setNombre(resultSet.getString(2));
				institucion.setNombreCorto(resultSet.getString(3));

				return institucion;

			}
		});
		return matches;
	}

	public List listaClaveParticipaSpei(InstitucionesBean institucion, int tipoLista){
		String query = "call INSTITUCIONESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	institucion.getNombre(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"InstitucionesDAO.listaInstitucion",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITUCIONESLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				InstitucionesBean institucion = new InstitucionesBean();
				institucion.setInstitucionID(String.valueOf(resultSet.getInt(1)));
				institucion.setClaveParticipaSpei(String.valueOf(resultSet.getInt(2)));
				institucion.setNombre(resultSet.getString(3));
				institucion.setNombreCorto(resultSet.getString(4));

				return institucion;

			}
		});
		return matches;
	}

	//Lista combo algoritmos
	public List listaComboAlgoritmos(int tipoLista, AlgoritmoDepRefBean algoritmoDepRefBean){
		String query = "call ALGORITMODEPREFLIS(?,?, ?,?,?, ?,?,?,?);";

		Object[] parametros = {
				Utileria.convierteEntero(algoritmoDepRefBean.getInstitucionID()),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"InstitucionesDAO.listaComboAlgoritmos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ALGORITMODEPREFLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				AlgoritmoDepRefBean bean = new AlgoritmoDepRefBean();

				bean.setAlgoritmoID(resultSet.getString("AlgoritmoID"));
				bean.setNombreAlgoritmo(resultSet.getString("NombreAlgoritmo"));

				return bean;
			}
		});

		return matches;
	}





}
