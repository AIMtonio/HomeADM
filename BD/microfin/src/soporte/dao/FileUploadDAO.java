package soporte.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.jdbc.core.JdbcTemplate;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import soporte.bean.ClienteArchivosBean;
import soporte.bean.CuentaArchivosBean;
import soporte.bean.InstrumentosArchivosBean;
import soporte.dao.InstrumentosArchivosDAO.Enum_TipoInstrumentos;

public class FileUploadDAO extends BaseDAO{
	InstrumentosArchivosDAO instrumentosArchivosDAO = null;
	public FileUploadDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	// ------------------ Transacciones ------------------------------------------


		/* Alta de Archivos de clientes */

		public MensajeTransaccionArchivoBean altaArchivosCliente(final ClienteArchivosBean archivo) {
			MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						String query = "call CLIENTEARCHIVOSALT(?,?,?,?,?,?,?,?,?,?,?);";
						Object[] parametros = {
								Utileria.convierteEntero(archivo.getClienteID()),
								archivo.getTipoDocumento(),
								archivo.getObservacion(),
								archivo.getRecurso(),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"FileUploadDAO.altaArchivosCliente",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSALT(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoString(String.valueOf(resultSet.getInt(4)));
							
							return mensaje;
						}
					});
			
					return matches.size() > 0 ? (MensajeTransaccionArchivoBean) matches.get(0) : null;
				}
					catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de archivos de cliente", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}
		/* Alta de Archivos de Cuentas */

		public MensajeTransaccionArchivoBean altaArchivosCta(final CuentaArchivosBean archivo) {
			MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
					try {
						String query = "call CUENTAARCHIVOSALT(?,?,?,?,?,?,?,?,?,?,?);";
						Object[] parametros = {
								Utileria.convierteLong(archivo.getCuentaAhoID()),
								archivo.getTipoDocumento(),
								archivo.getObservacion(),
								archivo.getRecurso(),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"FileUploadDAO.altaArchivosCta",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTAARCHIVOSALT(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoString(String.valueOf(resultSet.getInt(4)));
							
							return mensaje;
						}
					});
			
					return matches.size() > 0 ? (MensajeTransaccionArchivoBean) matches.get(0) : null;
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de archivos de cuenta", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
		
	/* Baja de Archivos de Cliente */
	public MensajeTransaccionArchivoBean  bajaArchivosCliente(final ClienteArchivosBean archivo) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					//Query con el Store Procedure
					String query = "call CLIENTEARCHIVOSBAJ(?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(archivo.getClienteID()),
							archivo.getTipoDocumento(),
							Utileria.convierteEntero(archivo.getArchivoClientID()),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"FileUploadDAO.bajaArchivosCliente",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSBAJ(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();			
										mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
										mensaje.setDescripcion(resultSet.getString(2));
										mensaje.setNombreControl(resultSet.getString(3));
										
										return mensaje;
				
						}
					});
							
					return matches.size() > 0 ? (MensajeTransaccionArchivoBean) matches.get(0) : null;
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de archivos de cliente", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	/* Baja de Archivos de Cuenta */
	public MensajeTransaccionArchivoBean  bajaArchivosCta(final CuentaArchivosBean archivo) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					//Query con el Store Procedure
					String query = "call CUENTAARCHIVOSBAJ(?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {Utileria.convierteLong(archivo.getCuentaAhoID()),
										   archivo.getTipoDocumento(),
										   Utileria.convierteEntero(archivo.getArchivoCuentaID()),
										   
										  Constantes.ENTERO_CERO,
										  Constantes.ENTERO_CERO,
										  Constantes.FECHA_VACIA,
										  Constantes.STRING_VACIO,
										   "FileUploadDAO.bajaArchivosCta",
										   Constantes.ENTERO_CERO,
										  Constantes.ENTERO_CERO};
					
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTAARCHIVOSBAJ(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();			
										mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
										mensaje.setDescripcion(resultSet.getString(2));
										mensaje.setNombreControl(resultSet.getString(3));
										
										return mensaje;
				
						}
					});
							
					return matches.size() > 0 ? (MensajeTransaccionArchivoBean) matches.get(0) : null;
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de archivos de cuenta", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	
	
	/* Consuta de Archivos del Cliente por Llave Principal*/
	public ClienteArchivosBean consultaPrincipalArchivosCliente(ClienteArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTEARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	archivo.getClienteID(),
								archivo.getTipoDocumento(),
								archivo.getArchivoClientID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FileUploadDAO.consultaPrincipalArchivosCliente",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivo = new ClienteArchivosBean();
					archivo.setClienteID(String.valueOf(resultSet.getInt(1)));
					archivo.setTipoDocumento(resultSet.getString(2));
					archivo.setArchivoClientID(String.valueOf(resultSet.getInt(3)));					
					archivo.setConsecutivo(String.valueOf(resultSet.getInt(4)));	
					archivo.setObservacion(resultSet.getString(5));
					archivo.setRecurso(resultSet.getString(6));
					
					return archivo;
			
			}
			
		});
				
		return matches.size() > 0 ? (ClienteArchivosBean) matches.get(0) : null;
	}
	
	
	/* Consuta de Archivos del Cliente por Llave Foranea para pantalla resumen de cliente*/
	public ClienteArchivosBean consultaForanea(ClienteArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTEARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	archivo.getClienteID(),
								archivo.getTipoDocumento(),
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FileUploadDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivo = new ClienteArchivosBean();
					archivo.setClienteID(String.valueOf(resultSet.getInt(1)));
					archivo.setRecurso(resultSet.getString(2));
					return archivo;
	
			}
		});
				
		return matches.size() > 0 ? (ClienteArchivosBean) matches.get(0) : null;
	}
	
	

	/* Consuta para ver la imagen de perfil del cliente*/
	public ClienteArchivosBean verImagenPerfil(ClienteArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTEARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	Utileria.convierteEntero(archivo.getClienteID()),
								Utileria.convierteEntero(archivo.getTipoDocumento()),
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FileUploadDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivo = new ClienteArchivosBean();
					archivo.setClienteID(String.valueOf(resultSet.getInt(1)));
					archivo.setRecurso(resultSet.getString(2));
					return archivo;
	
			}
		});
				
		return matches.size() > 0 ? (ClienteArchivosBean) matches.get(0) : null;
	}
	
	/* Consulta que nos devuelve el numero consecutivo que se insertara en la tabla*/
	public ClienteArchivosBean consultaNumeroSiguien(ClienteArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTEARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	Utileria.convierteEntero(archivo.getClienteID()),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FileUploadDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivo = new ClienteArchivosBean();
					archivo.setArchivoClientID(resultSet.getString(1));
					return archivo;
	
			}
		});
				
		return matches.size() > 0 ? (ClienteArchivosBean) matches.get(0) : null;
	}
	
	/* Consulta que devuelve un valor si ya existe un documento pld para un cliente*/
	public ClienteArchivosBean consultaArcPLD(ClienteArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTEARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	Utileria.convierteEntero(archivo.getClienteID()),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FileUploadDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivo = new ClienteArchivosBean();
					archivo.setClienteID(resultSet.getString(1));
					return archivo;
	
			}
		});
				
		return matches.size() > 0 ? (ClienteArchivosBean) matches.get(0) : null;
	}
	
	
	/* Consulta para ver el archivo*/
	public ClienteArchivosBean consultaArchivoCte(ClienteArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTEARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	archivo.getClienteID(),
								archivo.getTipoDocumento(),
								archivo.getArchivoClientID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FileUploadDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivo = new ClienteArchivosBean();
					archivo.setClienteID(resultSet.getString(1));
					archivo.setTipoDocumento(resultSet.getString(2));
					archivo.setArchivoClientID(resultSet.getString(3));
					archivo.setConsecutivo(resultSet.getString(4));
					archivo.setObservacion(resultSet.getString(5));
					archivo.setRecurso(resultSet.getString(6));
					return archivo;
	
			}
		});
				
		return matches.size() > 0 ? (ClienteArchivosBean) matches.get(0) : null;
	}
	
	
	/* Consulta que nos devuelve el numero consecutivo que se insertara en la tabla*/
	public CuentaArchivosBean consultaNumeroSiguienCta(CuentaArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CUENTAARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	archivo.getCuentaAhoID(),
								Utileria.convierteEntero(archivo.getTipoDocumento()),
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FileUploadDAO.consultaPrincipalArchivosCta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTAARCHIVOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentaArchivosBean archivo = new CuentaArchivosBean();
					archivo.setArchivoCuentaID(String.valueOf(resultSet.getInt(1)));					
					return archivo;
			}
			
		});
				
		return matches.size() > 0 ? (CuentaArchivosBean) matches.get(0) : null;
	}
	
	
	/* Consuta de Archivos de Cuenta por Llave Principal*/
	public CuentaArchivosBean consultaPrincipalArchivosCta(CuentaArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CUENTAARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	archivo.getCuentaAhoID(),
								archivo.getTipoDocumento(),
								archivo.getArchivoCuentaID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FileUploadDAO.consultaPrincipalArchivosCta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTAARCHIVOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentaArchivosBean archivo = new CuentaArchivosBean();
					archivo.setCuentaAhoID(String.valueOf(resultSet.getString(1)));
					archivo.setTipoDocumento(resultSet.getString(2));
					archivo.setArchivoCuentaID(String.valueOf(resultSet.getInt(3)));					
					archivo.setConsecutivo(String.valueOf(resultSet.getInt(4)));	
					archivo.setObservacion(resultSet.getString(5));
					archivo.setRecurso(resultSet.getString(6));
					
					return archivo;
			
			}
			
		});
				
		return matches.size() > 0 ? (CuentaArchivosBean) matches.get(0) : null;
	}
	
	/* Consuta de Archivos de Cuenta por Llave Foranea*/
	public CuentaArchivosBean consultaArchivoCta(CuentaArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CUENTAARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	archivo.getCuentaAhoID(),
								archivo.getTipoDocumento(),
								archivo.getArchivoCuentaID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FileUploadDAO.consultaArchivoCta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTAARCHIVOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentaArchivosBean archivo = new CuentaArchivosBean();
					archivo.setCuentaAhoID(String.valueOf(resultSet.getString(1)));
					archivo.setTipoDocumento(resultSet.getString(2));
					archivo.setArchivoCuentaID(resultSet.getString(3));
					archivo.setConsecutivo(resultSet.getString(4));
					archivo.setObservacion(resultSet.getString(5));
					archivo.setRecurso(resultSet.getString(6));
				return archivo;
	
			}
		});
				
		return matches.size() > 0 ? (CuentaArchivosBean) matches.get(0) : null;
	}
	
	/* Consuta de Firmas de la cuenta*/
	public CuentaArchivosBean consultaFirmaCta(CuentaArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CUENTAARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	archivo.getCuentaAhoID(),
								Utileria.convierteEntero(archivo.getTipoDocumento()),
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FileUploadDAO.consultaFirmaCta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTAARCHIVOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentaArchivosBean archivo = new CuentaArchivosBean();
					archivo.setCuentaAhoID(String.valueOf(resultSet.getString(1)));
					archivo.setTipoDocumento(resultSet.getString(2));
					archivo.setArchivoCuentaID(resultSet.getString(3));
					archivo.setConsecutivo(resultSet.getString(4));
					archivo.setObservacion(resultSet.getString(5));
					archivo.setRecurso(resultSet.getString(6));
				return archivo;
	
			}
		});
				
		return matches.size() > 0 ? (CuentaArchivosBean) matches.get(0) : null;
	}

	/* Consuta de Archivos de Cuenta por Llave Foranea*/
	public CuentaArchivosBean consultaForaneaArchivosCta(CuentaArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CUENTAARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	archivo.getCuentaAhoID(),
								archivo.getTipoDocumento(),
								archivo.getArchivoCuentaID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FileUploadDAO.consultaForaneaArchivosCta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTAARCHIVOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentaArchivosBean archivo = new CuentaArchivosBean();
					archivo.setCuentaAhoID(String.valueOf(resultSet.getString(1)));
					archivo.setTipoDocumento(resultSet.getString(2));
					archivo.setArchivoCuentaID(String.valueOf(resultSet.getInt(3)));					
					
					return archivo;
	
			}
		});
				
		return matches.size() > 0 ? (CuentaArchivosBean) matches.get(0) : null;
	}
	
	
	/*Consulta numero de arhivos por cuenta*/
	public CuentaArchivosBean consultaDocumentosPorCuenta(CuentaArchivosBean archivo, int tipoConsulta) {
		CuentaArchivosBean cuentaArchivosBeanConsulta  = new CuentaArchivosBean(); 
		try{
			String query = "call CUENTAARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
			
			Object[] parametros = {	archivo.getCuentaAhoID(),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"FileUploadDAO.consultaDocumentosPorCuenta",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTAARCHIVOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentaArchivosBean archivo = new CuentaArchivosBean();
						archivo.setNumeroDocumentos(String.valueOf(resultSet.getString("numeroDocumentos")));
						archivo.setClienteID(String.valueOf(resultSet.getString("clienteID")));
						return archivo;
		
				}
			});
			
			cuentaArchivosBeanConsulta= matches.size() > 0 ? (CuentaArchivosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de numeros de cuentas", e);
		}
		return cuentaArchivosBeanConsulta; 
	}

	
	
	/* Lista de Archivos por Cliente*/
	public List listaArchivosCliente(ClienteArchivosBean archivoBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTEARCHIVOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	
								archivoBean.getClienteID(),
								archivoBean.getTipoDocumento(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"FileUploadDAO.listaArchivosCliente",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
							
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivoBean = new ClienteArchivosBean();			
				archivoBean.setArchivoClientID(String.valueOf(resultSet.getInt(1)));
				archivoBean.setObservacion(resultSet.getString(2));
				archivoBean.setRecurso(resultSet.getString(3));
				archivoBean.setTipoDocumento(resultSet.getString(4));
				archivoBean.setConsecutivo(resultSet.getString(5));
				return archivoBean;				
			}
		});
				
		return matches;
	}
	
	
	
		
	/* Lista de Archivos por Cuenta*/
	public List listaArchivosCta(CuentaArchivosBean archivoBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CUENTAARCHIVOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	
								archivoBean.getCuentaAhoID(),
								archivoBean.getTipoDocumento(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"FileUploadDAO.listaArchivosCta",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTAARCHIVOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentaArchivosBean archivoBean = new CuentaArchivosBean();			
				archivoBean.setArchivoCuentaID(String.valueOf(resultSet.getInt(1)));
				archivoBean.setObservacion(resultSet.getString(2));
				archivoBean.setRecurso(resultSet.getString(3));
				archivoBean.setTipoDocumento(resultSet.getString(4));
				archivoBean.setConsecutivo(resultSet.getString(5));
				archivoBean.setDescTipoDoc(resultSet.getString(6));
				return archivoBean;	
			}
		});
				
		return matches;
	}	

	public MensajeTransaccionArchivoBean procBajaArchivosCta(final CuentaArchivosBean archivo) {
		MensajeTransaccionArchivoBean mensaje = null;
		
		final InstrumentosArchivosBean instrumArchivo = new InstrumentosArchivosBean();
		instrumArchivo.setArchivoBajID(archivo.getArchivoCuentaID());
		instrumArchivo.setNumeroInstrumento(archivo.getCuentaAhoID());
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
						mensajeBean = instrumentosArchivosDAO.altaArchivosAEliminar(instrumArchivo,Enum_TipoInstrumentos.cuenta);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						mensajeBean = bajaArchivosCta(archivo);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Archivos Eliminados de Cuentas.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public InstrumentosArchivosDAO getInstrumentosArchivosDAO() {
		return instrumentosArchivosDAO;
	}


	public void setInstrumentosArchivosDAO(
			InstrumentosArchivosDAO instrumentosArchivosDAO) {
		this.instrumentosArchivosDAO = instrumentosArchivosDAO;
	}

}
