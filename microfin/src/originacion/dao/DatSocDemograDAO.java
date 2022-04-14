package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;



import originacion.bean.DatSocDemogBean;

public class DatSocDemograDAO extends BaseDAO{
	public int mensajeExito=0;

	public DatSocDemograDAO() {
		super();
	}

 	//Graba Limite Quitas
	public MensajeTransaccionBean grabaDatosSocioDemo(final DatSocDemogBean datSocDemogBean){
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(

				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ArrayList listaDetalleGrid = null ;
				String [] arregloProductos = null;
				DatSocDemogBean iterDatSocDemogBean = null;
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					listaDetalleGrid = (ArrayList) detalleGrid(datSocDemogBean);



					mensajeBean = altaHisDatosSocioDemograf(datSocDemogBean );//ALTA HISTORIAL SOCIODEMOGRAFICOS
					if( mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean = altaDatosSocioDemograf(datSocDemogBean, parametrosAuditoriaBean.getNumeroTransaccion());// ALTA SOCIODEMOGRAAFICOS

					if( mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean = altaHisDatosDependEconom(datSocDemogBean );// ALTA HISTORIAL DEPENDIENTES ECONOMICOS

					if( mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}


					if(!listaDetalleGrid.isEmpty()) {
						for(int i=0; i < listaDetalleGrid.size(); i++){
							iterDatSocDemogBean = (DatSocDemogBean) listaDetalleGrid.get(i);
							mensajeBean = altaDatosDependEconom(iterDatSocDemogBean, parametrosAuditoriaBean.getNumeroTransaccion());
							if( mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}

						}
					}else{
						if( mensajeBean.getNumero()==0){

							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Datos Socio Demograficos grabados con Exito.");
							mensajeBean.setNombreControl("linNegID");
							mensajeBean.setConsecutivoString(mensajeBean.getConsecutivoString());
						}

					}



				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al grabar datos socioeconomicos demo", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});
		return mensajeResultado;
	}

	// metodo de alta de datos dependientes economicos
	public MensajeTransaccionBean altaDatosDependEconom(final DatSocDemogBean datSocDemogBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call SOCIODEMODEPENDALT(?,?,?,?,?,?,?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(datSocDemogBean.getProspID() ));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero( datSocDemogBean.getCliID()));
									sentenciaStore.setDate("Par_FechaRegistro",parametrosAuditoriaBean.getFecha()  );
									sentenciaStore.setInt("Par_TipoRelacionID",Utileria.convierteEntero( datSocDemogBean.getTipoRel()));
									sentenciaStore.setString("Par_PrimerNombre", datSocDemogBean.getPrimerNombre().trim());
									sentenciaStore.setString("Par_SegundoNombre", datSocDemogBean.getSegundNombre().trim());
									sentenciaStore.setString("Par_TercerNombre", datSocDemogBean.getTercerNombre().trim());
									sentenciaStore.setString("Par_ApellidoPaterno", datSocDemogBean.getApellidoPaterno().trim());
									sentenciaStore.setString("Par_ApellidoMaterno", datSocDemogBean.getApellidoMaterno().trim());
									sentenciaStore.setInt("Par_Edad", Utileria.convierteEntero(datSocDemogBean.getEdad()));
									sentenciaStore.setInt("Par_OcupacionID", Utileria.convierteEntero(datSocDemogBean.getOcupacion()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de datos dependientes economicos", e);
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


	// alta a historial de dependientes económicos
	public MensajeTransaccionBean altaHisDatosDependEconom(final DatSocDemogBean datSocDemogBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call HISSOCIODEMODEPALT(?,?, ?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(datSocDemogBean.getProspID() ));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero( datSocDemogBean.getCliID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico de datos dependientes economicos", e);
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



	// metodo de alta de datos  sociodemograficos
	public MensajeTransaccionBean altaDatosSocioDemograf (final DatSocDemogBean datSocDemogBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call SOCIODEMOGRALALT(?,?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(datSocDemogBean.getProspID() ));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero( datSocDemogBean.getCliID()));
									sentenciaStore.setDate("Par_FechaRegistro",parametrosAuditoriaBean.getFecha()  );
									sentenciaStore.setInt("Par_GradoEscolarID",Utileria.convierteEntero(datSocDemogBean.getGradoEscolarID()));
									sentenciaStore.setInt("Par_NumDepenEconomi",Utileria.convierteEntero(datSocDemogBean.getNumDepenEconomi()));
									sentenciaStore.setInt("Par_AntiguedadLab",Utileria.convierteEntero(datSocDemogBean.getAntiguedadLab()));
									sentenciaStore.setString("Par_FechaIniTrabajo",Utileria.convierteFecha(datSocDemogBean.getFechaIniTra()));


									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de datos sociodemografico", e);
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


	//alta a historial de datos sociodemograficos
	public MensajeTransaccionBean altaHisDatosSocioDemograf(final DatSocDemogBean datSocDemogBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call HISSOCIODEMOGRALALT(?,?, ?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(datSocDemogBean.getProspID() ));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero( datSocDemogBean.getCliID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de dato historico sociodemografico ", e);
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


	public DatSocDemogBean conGeneralPrincipal(DatSocDemogBean datSocDemogBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call SOCIODEMOGRALCON(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(datSocDemogBean.getProspectoID()),
				Utileria.convierteEntero(datSocDemogBean.getClienteID()),

				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOCIODEMOGRALCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DatSocDemogBean datSocDemogResulBean = new DatSocDemogBean();
				try {
					datSocDemogResulBean.setProspectoID(resultSet.getString("ProspectoID"));
					datSocDemogResulBean.setClienteID(resultSet.getString("ClienteID"));
					datSocDemogResulBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
					datSocDemogResulBean.setGradoEscolarID(resultSet.getString("GradoEscolarID"));
					datSocDemogResulBean.setDescriGdoEscolar(resultSet.getString("Descripcion"));
					datSocDemogResulBean.setNumDepenEconomi(resultSet.getString("NumDepenEconomi"));
					datSocDemogResulBean.setAntiguedadLab(resultSet.getString("AntiguedadLab"));
					datSocDemogResulBean.setFechaIniTra(resultSet.getString("FechaIniTrabajo"));
				} catch (Exception ex) {
					loggerSAFI.error("Error en consulta DatSocDemograDAO.conGeneralPrincipal:", ex);
					ex.printStackTrace();
					return null;
				}
				return datSocDemogResulBean;

			}
		});

		return matches.size() > 0 ? (DatSocDemogBean) matches.get(0) : null;
	}



	public List detalleGrid(DatSocDemogBean datSocDemogBean ){
		// Sepra las listas del grid en benes individuales

		List<String>  tipoRelacionL	= datSocDemogBean.getTipoRelacion();
		List<String>  primerNombL	= datSocDemogBean.getPrimerNomb();
		List<String>  segundNombL	= datSocDemogBean.getSegundNomb();
		List<String>  tercerNombL	= datSocDemogBean.getTercerNomb();
		List<String>  apePaternoL	= datSocDemogBean.getApePaterno();
		List<String>  apeMaternoL	= datSocDemogBean.getApeMaterno();
		List<String>  edadesL		= datSocDemogBean.getEdades();
		List<String>  ocupacionesL	= datSocDemogBean.getOcupaciones();

		ArrayList listaDetalle = new ArrayList();



		DatSocDemogBean iterDatSocDemogBean  = null;

			int tamanio = 0;
			if(tipoRelacionL!=null){
				tamanio=tipoRelacionL.size();
			}

			for(int i=0; i<tamanio; i++){
				iterDatSocDemogBean = new DatSocDemogBean();
				iterDatSocDemogBean.setCliID(datSocDemogBean.getCliID());
				iterDatSocDemogBean.setProspID(datSocDemogBean.getProspID());
				iterDatSocDemogBean.setTipoRel(tipoRelacionL.get(i));
				iterDatSocDemogBean.setPrimerNombre(primerNombL.get(i));
				iterDatSocDemogBean.setSegundNombre(segundNombL.get(i));
				iterDatSocDemogBean.setTercerNombre(tercerNombL.get(i));
				iterDatSocDemogBean.setApellidoPaterno(apePaternoL.get(i));
				iterDatSocDemogBean.setApellidoMaterno(apeMaternoL.get(i));
				iterDatSocDemogBean.setEdad(edadesL.get(i));
				iterDatSocDemogBean.setOcupacion(ocupacionesL.get(i));



				listaDetalle.add( iterDatSocDemogBean);
			}

		return listaDetalle;
	}


	public List listaTiposRelaciones(DatSocDemogBean datSocDemogBean, int tipoLista){
		List listaResultado=null;
		try{
			String query = "call TIPORELACIONESLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(datSocDemogBean.getTipoRel()),
					Constantes.STRING_VACIO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPORELACIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DatSocDemogBean datSocDemBean = new DatSocDemogBean();

					datSocDemBean.setTipoRel(resultSet.getString("TipoRelacionID"));
					datSocDemBean.setDescripRelacion(resultSet.getString("Descripcion"));

					return datSocDemBean;

				}
			});
			listaResultado = matches;
		}
		catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tipos de relaciones", e);
		}
		return listaResultado;
	}// fin lista tipos relaciones



	// lista  dependientes economicos Grid
	public List listaDepenEconomGrid (DatSocDemogBean datSocDemogBean, int tipoLista){
		List listaResultado=null;
		try{
			String query = "call SOCIODEMODEPENDLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					Utileria.convierteEntero(datSocDemogBean.getProspectoID()),
					Utileria.convierteEntero(datSocDemogBean.getClienteID()),
					tipoLista,


					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOCIODEMODEPENDLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DatSocDemogBean datSocDemBean = new DatSocDemogBean();


					datSocDemBean.setProspID(resultSet.getString("ProspectoID"));
					datSocDemBean.setCliID(resultSet.getString("ClienteID"));
					datSocDemBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
					datSocDemBean.setTipoRel(resultSet.getString("TipoRelacionID"));
					datSocDemBean.setPrimerNombre(resultSet.getString("PrimerNombre"));
					datSocDemBean.setSegundNombre(resultSet.getString("SegundoNombre"));
					datSocDemBean.setTercerNombre(resultSet.getString("TercerNombre"));
					datSocDemBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
					datSocDemBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
					datSocDemBean.setEdad(resultSet.getString("Edad"));
					datSocDemBean.setOcupacion(resultSet.getString("OcupacionID"));
					datSocDemBean.setDescripOcupacion(resultSet.getString("OcupacionDescripcion"));

					return datSocDemBean;

				}
			});
			listaResultado = matches;
		}
		catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista dependiente economico", e);
		}
		return listaResultado;
	}// fin lista tipos relaciones


	// lista Grado escolar
	public List listaGradoEscolar(DatSocDemogBean datSocDemogBean, int tipoLista){
		List listaResultado=null;
		try{
			String query = "call CATGRADOESCOLARLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					Utileria.convierteEntero(datSocDemogBean.getGradoEscolarID()),
					Constantes.STRING_VACIO,
					tipoLista,


					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATGRADOESCOLARLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DatSocDemogBean datSocDemBean = new DatSocDemogBean();

					datSocDemBean.setGradoEscolarID(resultSet.getString("GradoEscolarID"));
					datSocDemBean.setDescriGdoEscolar(resultSet.getString("Descripcion"));

					return datSocDemBean;

				}
			});
			listaResultado = matches;
		}
		catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grado escolar", e);
		}
		return listaResultado;
	}// fin lista Grado escolar



}//cierra llave  fin de la clase
