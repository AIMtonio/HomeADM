package soporte.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
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

import soporte.bean.ProcesosETLBean;

public class ProcesosETLDAO extends BaseDAO{
	public ProcesosETLDAO(){
		super();
	}

	/**
	 * Metodo para ejecutar un sh que procesara job principal de un proceso ETL
	 * @param procesosETLBean : Bean con el ID del proceos ETL (TABLA PROCESOSETL)
	 * @param parametros : Arreglo de String con lista de parametros que se optienen de pantalla o que no estan en la tabla PROCESOSETL
	 * @return MensajeTransaccionBean : Regresa el resultado de la ejecución del sh y ETL, con numero y mensaje de error
	 */
	public MensajeTransaccionBean procesarArchivoSH(ProcesosETLBean procesosETLBean, String[] parametros){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(999);
		try{

			//VALIDACIONES POR ID DE PROCESO ETL
			mensaje = validaProcesoETL(procesosETLBean);
			if (mensaje.getNumero() != Constantes.CODIGO_SIN_ERROR) {
				throw new Exception(mensaje.getDescripcion());
			}

			//consulta los parametros del ETL
			int tipoConsulta = 1;
			procesosETLBean = conProcesoETL(procesosETLBean, tipoConsulta);

			if(Utileria.convierteEntero(procesosETLBean.getProcesoETLID()) > 0){

				String [] arreglo = null;
				String rutaNombreSH = procesosETLBean.getRutaArchivoSH();
				arreglo = rutaNombreSH.split("\\/");
				String nombreSH = arreglo[arreglo.length-1];//ultima posicion arreglo es nombre del sh
				String rutaSH = rutaNombreSH.substring(0, rutaNombreSH.length()-nombreSH.length());

				loggerSAFI.info(this.getClass()+" - "+"Inicio Ejecucion SH"+" - "+"Ruta: "+rutaSH+" - "+"Nombre sh: "+nombreSH);

		        ArrayList<String> command = new ArrayList<String>();

		        command.add("/bin/bash");
		        command.add(nombreSH);

				// PARAMETROS BD ETL SIEMPRE 1 Y 2
		        command.add(procesosETLBean.getRutaCarpetaETL());// "Par_RutaCarpetaETL"
		        command.add(procesosETLBean.getRutaCarpetaPentaho());// "Par_CarpetaPentaho"

		        // PARAMETROS RECIBE
				for(String param : parametros){
			        command.add(param);
				}


				loggerSAFI.info(this.getClass()+" - "+"Command SH"+" - "+command);

				// Valida si existe el archivo SH
				File directorio = new File(rutaSH+nombreSH);
				if (!directorio.exists()) {
					throw new Exception("No se existe el archivo sh en la ruta especificada.");
				}

				ProcessBuilder pb = new ProcessBuilder(command);
				pb.directory(new File(rutaSH));

				Process p = pb.start();
				//p.waitFor();
				// LEEMOS SALIDA DEL PROGRAMA
				InputStream is = p.getInputStream();
				InputStreamReader isr = new InputStreamReader(is);
				BufferedReader br = new BufferedReader(isr);

				String line;
				String respuesta = null;
				while ((line = br.readLine()) != null) {
					loggerSAFI.info(line);
					respuesta = line;
				}

				String[] partes = respuesta.split("-");
				int codigoRespuesta = Integer.parseInt(partes[0]);
				String mensajeRespuesta = partes[1];
				loggerSAFI.info(this.getClass()+" - "+"Respuesta recibida del SH: " +respuesta);
				loggerSAFI.info(this.getClass()+" - "+"Fin Ejecucion SH"+" - "+"Nombre sh: "+nombreSH);

				mensaje.setNumero(codigoRespuesta);
				mensaje.setDescripcion("RespuestaETL: "+mensajeRespuesta);
			}else{
				throw new Exception("El proceso ETL no existe.");
			}
		}catch(Exception e){
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error al procesar el archivo SH del ETL:  "+procesosETLBean.getProcesoETLID()+" - " + e);
			e.printStackTrace();
			if (mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR) {
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion("RespuestaETL: "+e.getMessage());
		}

		return mensaje;
	}

	/**
	 * Metodo para validaciones del proceso ETL
	 * @param procesosETLBean : Bean con el ID del proceos ETL (TABLA PROCESOSETL)
	 * @return MensajeTransaccionBean : Regresa el resultado de las validaciones, con numero y mensaje de error
	 */
	public MensajeTransaccionBean validaProcesoETL(final ProcesosETLBean procesosETLBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call PROCESOSETLVAL(?," +
														"?,?,?," +			// parametros de salida
														"?,?,?,?,?,?,?);"; 	// parametros auditoria

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ProcesoETLID",Utileria.convierteEntero(procesosETLBean.getProcesoETLID()));

								//Parametros de Salida
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ProcesosETLDAO.validaProcesoETL");
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
						throw new Exception(Constantes.MSG_ERROR + " .ProcesosETLDAO.validaProcesoETL");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en proceso de validacion de procesos ETL" + e);
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

	/**
	 * Metodo para consultar los parametros del proceso ETL
	 * @param procesosETLBean : Bean con el ID del proceos ETL (TABLA PROCESOSETL)
	 * @param tipoConsulta : numero de consulta
	 * @return ProcesosETLBean : Regresa bean con parametros del ETL
	 */
	public ProcesosETLBean conProcesoETL(ProcesosETLBean procesosETLBean, int tipoConsulta){
		ProcesosETLBean bean = null;
		try{
			String query = "call PROCESOSETLCON(" +
					"?,?," +
					"?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteLong(procesosETLBean.getProcesoETLID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ProcesosETLDAO.conProcesoETL",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROCESOSETLCON(" + Arrays.toString(parametros) +")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ProcesosETLBean procesosETLBean = new ProcesosETLBean();

					procesosETLBean.setProcesoETLID(resultSet.getString("ProcesoETLID"));
					procesosETLBean.setRutaArchivoSH(resultSet.getString("RutaArchivoSH"));
					procesosETLBean.setRutaCarpetaETL(resultSet.getString("RutaCarpetaETL"));
					procesosETLBean.setRutaCarpetaPentaho(resultSet.getString("RutaCarpetaPentaho"));
					procesosETLBean.setDescripcion(resultSet.getString("Descripcion"));
					return procesosETLBean;
				}
			});
			bean = matches.size() > 0 ? (ProcesosETLBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de proceso ETL", e);
		}
		return bean;
	}
}
