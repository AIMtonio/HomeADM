package cedes.dao;

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
	import cedes.bean.CedesArchivosBean;

	public class CedesFileUploadDAO extends BaseDAO{
		
		public CedesFileUploadDAO() {
			super();
			// TODO Auto-generated constructor stub
		}
		// ------------------ Transacciones ------------------------------------------
 
			/* Alta de Archivos de CEDES */

			public MensajeTransaccionArchivoBean altaArchivosCta(final CedesArchivosBean archivo) {
				MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
				transaccionDAO.generaNumeroTransaccion();
				mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
						try {
							String query = "call CEDESARCHIVOSALT(?,?,?,?,?,?,?,?,?,?,?,?);";
							Object[] parametros = {
									Utileria.convierteEntero(archivo.getCedeID()),
									archivo.getTipoDocumento(),
									archivo.getObservacion(),
									archivo.getRecurso(),
									archivo.getComentario(),
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"FileUploadDAO.altaArchivosCta",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESARCHIVOSALT(" + Arrays.toString(parametros) +")");
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
		
		
		/* Baja de Archivos de CEDES */
		public MensajeTransaccionArchivoBean  bajaArchivosCta(final CedesArchivosBean archivo) {
			MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
			
			mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
					try {
						//Query con el Store Procedure
						String query = "call CEDESARCHIVOSBAJ(?,?,?,?,?,?,?,?,?,?);";
						Object[] parametros = {Utileria.convierteEntero(archivo.getCedeID()),
											   archivo.getTipoDocumento(),
											   Utileria.convierteEntero(archivo.getArchivoCuentaID()),
											   
											  Constantes.ENTERO_CERO,
											  Constantes.ENTERO_CERO,
											  Constantes.FECHA_VACIA,
											  Constantes.STRING_VACIO,
											   "InverFileUploadDAO.bajaArchivosCta",
											   Constantes.ENTERO_CERO,
											  Constantes.ENTERO_CERO};
						
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESARCHIVOSBAJ(" + Arrays.toString(parametros) +")");
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
		
	

		/* Consulta que nos devuelve el numero consecutivo que se insertara en la tabla*/
		public CedesArchivosBean consultaNumeroSiguienCta(CedesArchivosBean archivo, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call CEDESARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
			
			Object[] parametros = {	archivo.getCedeID(),
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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESARCHIVOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesArchivosBean archivo = new CedesArchivosBean();
						archivo.setArchivoCuentaID(String.valueOf(resultSet.getInt(1)));					
						return archivo;
				}
				
			});
					
			return matches.size() > 0 ? (CedesArchivosBean) matches.get(0) : null;
		}
		
		
		/* Consuta de Archivos de Cuenta por Llave Principal*/
		public CedesArchivosBean consultaPrincipalArchivosCta(CedesArchivosBean archivo, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call CEDESARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
			
			Object[] parametros = {	archivo.getCedeID(),
									archivo.getTipoDocumento(),
									archivo.getArchivoCuentaID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CedesArchivosDAO.consultaPrincipalArchivosCta",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESARCHIVOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesArchivosBean archivo = new CedesArchivosBean();
						archivo.setCedeID(String.valueOf(resultSet.getInt(1)));
						archivo.setTipoDocumento(resultSet.getString(2));
						archivo.setArchivoCuentaID(String.valueOf(resultSet.getInt(3)));					
						archivo.setConsecutivo(String.valueOf(resultSet.getInt(4)));	
						archivo.setObservacion(resultSet.getString(5));
						archivo.setRecurso(resultSet.getString(6));
						
						return archivo;
				
				}
				
			});
					
			return matches.size() > 0 ? (CedesArchivosBean) matches.get(0) : null;
		}
		
		/* Consuta de Archivos de Cuenta por Llave Foranea*/
		public CedesArchivosBean consultaArchivoCta(CedesArchivosBean archivo, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call CEDESARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
			
			Object[] parametros = {	archivo.getCedeID(),
									archivo.getTipoDocumento(),
									archivo.getArchivoCuentaID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CedesArchivosDAO.consultaArchivoCta",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESARCHIVOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesArchivosBean archivo = new CedesArchivosBean();
						archivo.setCedeID(String.valueOf(resultSet.getInt(1)));
						archivo.setTipoDocumento(resultSet.getString(2));
						archivo.setArchivoCuentaID(resultSet.getString(3));
						archivo.setConsecutivo(resultSet.getString(4));
						archivo.setObservacion(resultSet.getString(5));
						archivo.setRecurso(resultSet.getString(6));
					return archivo;
		
				}
			});
					
			return matches.size() > 0 ? (CedesArchivosBean) matches.get(0) : null;
		}
		
		/* Consuta de Firmas de la cuenta*/
		public CedesArchivosBean consultaFirmaCta(CedesArchivosBean archivo, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call CEDESARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
			
			Object[] parametros = {	archivo.getCedeID(),
									Utileria.convierteEntero(archivo.getTipoDocumento()),
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CedesFileUploadDAO.consultaFirmaCta",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESARCHIVOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesArchivosBean archivo = new CedesArchivosBean();
						archivo.setCedeID(String.valueOf(resultSet.getInt(1)));
						archivo.setTipoDocumento(resultSet.getString(2));
						archivo.setArchivoCuentaID(resultSet.getString(3));
						archivo.setConsecutivo(resultSet.getString(4));
						archivo.setObservacion(resultSet.getString(5));
						archivo.setRecurso(resultSet.getString(6));
					return archivo;
		
				}
			});
					
			return matches.size() > 0 ? (CedesArchivosBean) matches.get(0) : null;
		}

		/* Consuta de Archivos de Cuenta por Llave Foranea*/
		public CedesArchivosBean consultaForaneaArchivosCta(CedesArchivosBean archivo, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call CEDESARCHIVOSCON(?,?,?,?,?,?,?,?,?,?,?);";
			
			Object[] parametros = {	archivo.getCedeID(),
									archivo.getTipoDocumento(),
									archivo.getArchivoCuentaID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CedesArchivosDAO.consultaForaneaArchivosCta",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESARCHIVOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesArchivosBean archivo = new CedesArchivosBean();
						archivo.setCedeID(String.valueOf(resultSet.getInt(1)));
						archivo.setTipoDocumento(resultSet.getString(2));
						archivo.setArchivoCuentaID(String.valueOf(resultSet.getInt(3)));					
						
						return archivo;
		
				}
			});
					
			return matches.size() > 0 ? (CedesArchivosBean) matches.get(0) : null;
		}
		
	
		/* Lista de Archivos por Cuenta*/
		public List listaArchivosCta(CedesArchivosBean archivoBean, int tipoLista) {
			//Query con el Store Procedure
			String query = "call CEDESARCHIVOSLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	
									archivoBean.getCedeID(),
									archivoBean.getTipoDocumento(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"FileUploadDAO.listaArchivosCta",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESARCHIVOSLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesArchivosBean archivoBean = new CedesArchivosBean();			
					archivoBean.setArchivoCuentaID(String.valueOf(resultSet.getInt(1)));
					archivoBean.setObservacion(resultSet.getString(2));
					archivoBean.setRecurso(resultSet.getString(3));
					archivoBean.setTipoDocumento(resultSet.getString(4));
					archivoBean.setConsecutivo(resultSet.getString(5));
					return archivoBean;	
				}
			});
					
			return matches;
		}	

		
	}


