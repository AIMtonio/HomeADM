package tesoreria.dao;

import java.io.File;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.pentaho.di.core.KettleEnvironment;
import org.pentaho.di.core.logging.LogLevel;
import org.pentaho.di.job.Job;
import org.pentaho.di.job.JobMeta;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import tesoreria.bean.CuentasAhoTesoBean;
import tesoreria.bean.DispersionMasivaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class DispersionMasivaDAO extends BaseDAO{

	public DispersionMasivaDAO(){
		super();
	}

	public MensajeTransaccionBean validaCargaArchivo(final DispersionMasivaBean dispersionMasivaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String rutaJob = "/opt/SAFI/ETLS/ktrPrincipal/TESORERIA/DispersionMasiva/JOB/cargaArchivoDispersion.kjb";
					String extension = "";
					int i = dispersionMasivaBean.getRutaArchivo().lastIndexOf('.');
					extension = dispersionMasivaBean.getRutaArchivo().substring(i + 1);
					KettleEnvironment.init();
					JobMeta jobmeta = new JobMeta(rutaJob, null);
					Job job = new Job(null, jobmeta);
					jobmeta.setParameterValue("Par_ArchivoExcel",   dispersionMasivaBean.getRutaArchivo());
					jobmeta.setParameterValue("Par_Extencion", extension);
					jobmeta.setParameterValue("Par_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion()+"");
					jobmeta.setLogLevel(LogLevel.DETAILED);
					jobmeta.setInternalKettleVariables(job);
					jobmeta.activateParameters();
					job.shareVariablesWith(jobmeta);
					job.start();
					job.waitUntilFinished();

					if(job.getErrors()>0){
						mensajeBean.setNumero(999);
						mensajeBean.setConsecutivoString(parametrosAuditoriaBean.getNumeroTransaccion()+"");
						mensajeBean.setDescripcion("Ha ocurrido un Error. No se pudo completar la validación del archivo.<br/>"+"Error durante la ejecución del job: " + rutaJob);
						mensajeBean.setNombreControl("adjuntar");
						eliminaArchivo(dispersionMasivaBean.getRutaArchivo());
						throw new RuntimeException("Error durante la ejecución del job: " + rutaJob);
					}else{
						mensajeBean = validaArchivoCarga(dispersionMasivaBean,parametrosAuditoriaBean.getNumeroTransaccion());

						if(mensajeBean.getNumero() != 0){
							MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
							mensajeBaja = bajaCargaArchivo(parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBaja.getNumero() == 0){
								eliminaArchivo(dispersionMasivaBean.getRutaArchivo());
							}
						}
					}

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al procesar la informacion de validacion archivo carga masiva dispersion.", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					transaction.setRollbackOnly();
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensaje;


	}



	public MensajeTransaccionBean validaArchivoCarga(final DispersionMasivaBean dispersionMasivaBean, final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							// Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call CARGAMASIVADISPVAL("
													+ "?,?,?,?,	"
													+ "?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?);";

											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(dispersionMasivaBean.getInstitucionID()));
											sentenciaStore.setString("Par_NumCtaInstit",dispersionMasivaBean.getNumCtaInstit());
											sentenciaStore.setString("Par_FechaDispersion", dispersionMasivaBean.getFechaDisp());
											sentenciaStore.setString("Par_RutaArchivo", dispersionMasivaBean.getRutaArchivo());

											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

											sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
											sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
											sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

											sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
											sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
											sentenciaStore.setString("Aud_ProgramaID","DispersionMasivaDAO.validaArchivoCarga");
											sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
											sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

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
												mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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

							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de validacion de archivo de carga masiva de dispersion", e);
							return mensajeBean;
						}
						return mensajeBean;
					}
				});
		return mensaje;
	}



	public MensajeTransaccionBean procesaArchivoCarga(final DispersionMasivaBean dispersionMasivaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							// Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call CARGAMASIVADISPPRO("
													+ "?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?);";

											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

											sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
											sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
											sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

											sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
											sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
											sentenciaStore.setString("Aud_ProgramaID","DispersionMasivaDAO.procesaArchivoCarga");
											sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
											sentenciaStore.setLong("Aud_NumTransaccion", Utileria.convierteLong(dispersionMasivaBean.getNumTransaccion()));

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
												mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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

							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion(e.getMessage());
							}else{
							mensajeBean.setDescripcion(e.getMessage());
							}
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de validacion de archivo de carga masiva de dispersion", e);
							transaction.setRollbackOnly();
						}
						return mensajeBean;
					}
				});
		return mensaje;
	}



	public MensajeTransaccionBean bajaCargaArchivo(final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							// Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call TMPCARGAMASIVADISPBAJ("
													+ "?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?);";

											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

											sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
											sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
											sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

											sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
											sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
											sentenciaStore.setString("Aud_ProgramaID","DispersionMasivaDAO.BajaCargaArchivo");
											sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
											sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

											loggerSAFI.info("####### Se procede a la Baja de los registro se encontraron validaciones ####");
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
												mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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

							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de baja de archivo de carga masiva de dispersion", e);
						}
						return mensajeBean;
					}
				});
		return mensaje;
	}


	public List listaValidacion(final DispersionMasivaBean dispersionMasivaBean, int tipoLista) {
		// Query con el Store Procedure
		String query = "call VALCARGAMASIVADISPLIS(?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"DispersionMAsivaDAO.listaValidacion",
				parametrosAuditoriaBean.getSucursal(),
				Utileria.convierteLong(dispersionMasivaBean.getNumTransaccion()) };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call VALCARGAMASIVADISPLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				DispersionMasivaBean dispersionMasivaBean = new DispersionMasivaBean();
				dispersionMasivaBean.setLinea(resultSet.getString("Fila"));
				dispersionMasivaBean.setValidacion(resultSet.getString("Validacion"));
				return dispersionMasivaBean;
			}
		});

		return matches;
	}



	public boolean eliminaArchivo(String archivo){
		 boolean estatus = false;
		try{
            File file = new File(archivo);
            estatus = file.delete();
            loggerSAFI.info("Archivo dado de baja correctamente.");
        }catch(Exception e){
        	e.printStackTrace();
        	loggerSAFI.info("Error al  eliminar el archivo ",e);
        }
		return estatus;
	}

}
