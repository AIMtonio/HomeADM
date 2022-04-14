package tesoreria.dao;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
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

import tesoreria.bean.CuentasSantanderBean;
import tesoreria.bean.ResOrdPagoSantaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ResOrdPagoSantaDAO extends BaseDAO{
	CuentasSantanderDAO cuentasSantanderDAO = null;
	CuentasSantanderBean cuentasSantander = null;

	//EJETUTAMOS EL SH PARA EL PROCESO DE ARCHIVO
	public MensajeTransaccionBean procesaArchivoTransfer(ResOrdPagoSantaBean resOrdPagoSantaBean, String rutaProteties){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		try{
			//Generacion de archivos de Estado de Cuentas
			if(resOrdPagoSantaBean.getExtensionArchivo().equals("txt")){
				resOrdPagoSantaBean.setDelimitador("|");
			}
			if(resOrdPagoSantaBean.getExtensionArchivo().equals("csv")){
				resOrdPagoSantaBean.setDelimitador(",");
			}


			String shProcesaRespuesta = "/opt/SAFI/ETLS/TESORERIA/DISPSANTANDER/ProcesaArchSantander.sh";

			loggerSAFI.info("\nDatos:" + shProcesaRespuesta+
							"\n[\n	transaccion:"+parametrosAuditoriaBean.getNumeroTransaccion()+
							"\n	CtasActivas:"+
							"\n	CtasPedientes:"+
							"\n	Transferencias: "+
							"\n	OrdenPago: "+resOrdPagoSantaBean.getRutaArchivo()+
							"\n]");

			//Procesando el SH
			String[] command = {"bash",
					shProcesaRespuesta,
					Constantes.STRING_VACIO,											// RUTA DE ARCHIVO DE CUENTAS ACTIVAS
					Constantes.STRING_VACIO,											// RUTA DE ARCHIVO DE CUENTAS PENDIENTES
					Constantes.STRING_VACIO,											// FECHA DEL SISTEMA
					Constantes.STRING_VACIO,											// NOMBRE DEL ARCHIVO DE CUENTAS ACTIVAS
					Constantes.STRING_VACIO,											// NOMBRE DEL ARCHIVO DE CUENTAS PENDIENTES
					Constantes.STRING_VACIO,											// DELIMITADOR DEL ARCHIVO 1
					Constantes.STRING_VACIO,											// DELIMITADOR DEL ARCHIVO 2
					String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()),		// NUMERO DE TRANSACCION
					String.valueOf(parametrosAuditoriaBean.getFecha()),					// FECHA DEL SISTEMA
					rutaProteties,														// RUTA DE ARCHIVO DE CONFIGURACION DE CONEXIONES
					Constantes.STRING_VACIO,											// RUTA DEL ARCHIVO DE RESPUESTA DE SANTANDER TRANSFERENCIAS
					Constantes.STRING_VACIO,											// NOMBRE DEL ARCHIVO DE TRANSFERENCIAS SANTANDER
					resOrdPagoSantaBean.getRutaArchivo(),								// RUTA DEL ARCHIVO DE ORDEN DE PAGO
					resOrdPagoSantaBean.getArchivo(),									// NOMBRE DEL ARCHVIO DE ORDEN DE PAGO
			};

			ProcessBuilder pb = new ProcessBuilder(command);
			pb.command(command);
			loggerSAFI.info(this.getClass()+" - "+"Inicio Ejecucion ETL por SH");
			Process p = pb.start();
			p.waitFor();
			loggerSAFI.info(this.getClass()+" - "+"Fin Ejecucion ETL por SH");

			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader bufferedR = new BufferedReader(isr);
			String line;
			String respuesta = null;
			String mensajeDispersionSan ="";

			while ((line = bufferedR.readLine()) != null) {
				respuesta = line;
			}
			String[] partes = respuesta.split("-");
			int codigoRespuesta = Utileria.convierteEntero(partes[0]);
			String mensajeRespuesta = partes[1];

			mensaje.setNumero(codigoRespuesta);
			mensaje.setDescripcion(mensajeRespuesta);

			mensajeDispersionSan = mensajeRespuesta;

			cuentasSantander = new CuentasSantanderBean();
			cuentasSantander.setArchivoProceso(resOrdPagoSantaBean.getArchivo());
			//VALIDAMOS SI EXISTE UN ERROR AL PROCESAR LOS ARCHIVOS, LOS ELIMINAMOS
			if(mensaje.getNumero()==0){
				//ELIMINAMOS LOS REGISTROS BASURA QUE DEJA EL KTR
				mensaje = cuentasSantanderDAO.bajaArchivoCtas(cuentasSantander, 5);
				if(mensaje.getNumero()==0){
					//PROCESAMOS LA INFORMACION CORRESPONDIENTE AL ARCHIVO
					mensaje = procesaInfDisperOrdenPago(resOrdPagoSantaBean, 2);
					mensajeDispersionSan = mensaje.getDescripcion();
				}

			}

			if(mensaje.getNumero()!=0){
				//ELIMINAMOS LA INFORMACION DE LA TABLA DE DISPORDENPAGOSAN
				mensaje = cuentasSantanderDAO.bajaArchivoCtas(cuentasSantander, 4);
				Utileria.borraArchivo(resOrdPagoSantaBean.getRutaArchivo());
				mensaje.setNumero(999);
				mensaje.setDescripcion("Disculpe las molestias, a ocurrido un error al procesar el archivo ["+resOrdPagoSantaBean.getArchivo()+"].<br><br>"+mensajeDispersionSan);
			}

		}catch(IllegalThreadStateException e){
			mensaje.setNumero(Integer.valueOf("001"));
			mensaje.setDescripcion("Error al procesar los archivos.");
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en procesar los archivos. ", e);
		}
		return mensaje;
	}

	// SE PROCESA INFORMACION DE LAS ORDENES DE PAGOS
	public MensajeTransaccionBean procesaInfDisperOrdenPago(final ResOrdPagoSantaBean resOrdPagoSantaBean, final int tipoAct){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DISPSANTANDERMINISPRO(?,?,?,?,?,		" +
																			   "?,?,?,?,?,		" +
																			   "?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_NombreArchivo", resOrdPagoSantaBean.getArchivo());
								    sentenciaStore.setInt("Par_TipoAct",tipoAct);

								    //Parametros de OutPut
								    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									MensajeTransaccionBean mensajeBloqueo = null;

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));


									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ResTransferenciaSantaDAO.procesaInfDisperTransfer");
									}
									return mensajeTransaccion;
								}
							});

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ResOrdPagoSantaDAO.procesaInfDisperOrdenPago");
						}else if(mensajeBean.getNumero()!=0){
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Dispersion SANTANDER: " + mensajeBean.getDescripcion());
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al procesar la informacion de dispersiones transferencia.", e);
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

	//CONSULTA PRINCIPAL
	public ResOrdPagoSantaBean consultaPrincipal(ResOrdPagoSantaBean resOrdPagoSanta, int tipoConsulta){
		String query = "call DISPRESPUESTAORDPAGOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				resOrdPagoSanta.getArchivo(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"OperDispersionDao.conFolioOperacinon",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPRESPUESTAORDPAGOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				ResOrdPagoSantaBean resOrdPagoSanta = new ResOrdPagoSantaBean();
				resOrdPagoSanta.setContVencido(resultSet.getString("ContVencido"));
				resOrdPagoSanta.setContCancelado(resultSet.getString("ContCancelado"));
				resOrdPagoSanta.setContLiquidado(resultSet.getString("ContLiquidado"));
				resOrdPagoSanta.setContPendiente(resultSet.getString("ContPendiente"));
				return resOrdPagoSanta;
			}
		});
		return matches.size() > 0 ? (ResOrdPagoSantaBean) matches.get(0) : null;
	}	//FIN con Folio de operacion

	//CONSULTA PRINCIPAL
		public ResOrdPagoSantaBean consultaArchivo(ResOrdPagoSantaBean resOrdPagoSanta, int tipoConsulta){
			String query = "call DISPARCRESPUESTASANCON(?,?,			" +
														"?,?,?,?,?,?,?	);";
			Object[] parametros = {
					resOrdPagoSanta.getArchivo(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"OperDispersionDao.consultaArchivo",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPARCRESPUESTASANCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ResOrdPagoSantaBean resOrdPagoSanta = new ResOrdPagoSantaBean();
					resOrdPagoSanta.setArchivo(resultSet.getString("Archivo"));
					return resOrdPagoSanta;
				}
			});
			return matches.size() > 0 ? (ResOrdPagoSantaBean) matches.get(0) : null;
		}
	public CuentasSantanderDAO getCuentasSantanderDAO() {
		return cuentasSantanderDAO;
	}

	public void setCuentasSantanderDAO(CuentasSantanderDAO cuentasSantanderDAO) {
		this.cuentasSantanderDAO = cuentasSantanderDAO;
	}

	public CuentasSantanderBean getCuentasSantander() {
		return cuentasSantander;
	}

	public void setCuentasSantander(CuentasSantanderBean cuentasSantander) {
		this.cuentasSantander = cuentasSantander;
	}

}
