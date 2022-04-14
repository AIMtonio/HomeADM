package seguimiento.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import seguimiento.bean.SegtoArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SegtoArchivoDAO extends BaseDAO{

	public SegtoArchivoDAO(){
		super();
	}

	public MensajeTransaccionBean grabaListaAclaraArch(final SegtoArchivoBean segtoArchivoBean, final List listaArchAdjuntos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				MensajeTransaccionBean mensajeBeanSalida = new MensajeTransaccionBean();
				try {
					SegtoArchivoBean rangoArchivosBean;
					mensajeBean = bajaSegtoArchivos(segtoArchivoBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaArchAdjuntos.size(); i++){
						rangoArchivosBean = (SegtoArchivoBean)listaArchAdjuntos.get(i);
						mensajeBean = altaSegtoArchivos(rangoArchivosBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBeanSalida.setNumero(0);
					mensajeBeanSalida.setDescripcion("Informacion Actualizada.");
					mensajeBeanSalida.setConsecutivoString(mensajeBean.getConsecutivoString());
					mensajeBeanSalida.setNombreControl(mensajeBean.getNombreControl());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBeanSalida.setNumero(999);
					}
					mensajeBeanSalida.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la aclaracion de archivos ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*Alta de archivos aclaraciones*/
	public MensajeTransaccionBean altaSegtoArchivos(final SegtoArchivoBean segtoArchivoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGTOARCHIVOSALT(?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SegtoID",Utileria.convierteEntero(segtoArchivoBean.getSegtoPrograID()));
									sentenciaStore.setString("Par_SecuenciaID",segtoArchivoBean.getConsecutivoID());
									sentenciaStore.setString("Par_FolioID",segtoArchivoBean.getFolioID());
									sentenciaStore.setString("Par_Ruta",segtoArchivoBean.getRutaArchivo());
									sentenciaStore.setString("Par_NombreArchivo",segtoArchivoBean.getNombreArchivo());

									sentenciaStore.setString("Par_TipoDocumentoID",segtoArchivoBean.getTipoDocumentoID());
									sentenciaStore.setString("Par_Comentario",segtoArchivoBean.getComentaAdjunto());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TarDebAclaraDAO");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								} //public sql exception
							} // new CallableStatementCreator
							,new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosAclara = callableStatement.getResultSet();

										resultadosAclara.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosAclara.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosAclara.getString(2));
										mensajeTransaccion.setNombreControl(resultadosAclara.getString(3));
										//mensajeTransaccion.setConsecutivoString(resultadosAclara.getString(4));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}// public
							});// CallableStatementCallback
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
						} catch (Exception e) {
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de la aclaracion", e);
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
						}// catch
						return mensajeBean;
					} // public Object doInTransaction
		}); //men
		return mensaje;
	}
	/* Baja de archivos de aclaraciones */
	public MensajeTransaccionBean bajaSegtoArchivos(SegtoArchivoBean segtoArchivoBean) {
		String query = "call SEGTOARCHIVOSBAJ(?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
					segtoArchivoBean.getSegtoPrograID(),
					segtoArchivoBean.getNumSecuencia(),

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"SegtoArchivoDAO.bajaSegtoArchivos",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOARCHIVOSBAJ(  " + Arrays.toString(parametros) + ")");

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

		return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}

	/* Lista de archivos de seguimientos*/
	public List listaSegtoArchivos(SegtoArchivoBean segtoArchivoBean, int tipoLista) {
		List listaAclaraArchivos=null;
		try{
		String query = "call SEGTOARCHIVOSLIS(?,?,?,  ?,?,?,?, ?,?,?);";
		Object[] parametros = {
								segtoArchivoBean.getSegtoPrograID(),
								segtoArchivoBean.getNumSecuencia(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TarDebArchAclaDAO.listaAclaraArchivos",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOARCHIVOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				SegtoArchivoBean segtoArchivo = new SegtoArchivoBean();
				segtoArchivo.setSegtoPrograID(resultSet.getString(1));
				segtoArchivo.setNumSecuencia(resultSet.getString(2));
				segtoArchivo.setFolioID(resultSet.getString(3));
				segtoArchivo.setFecha(resultSet.getString(4));
				segtoArchivo.setRutaArchivo(resultSet.getString(5));
				segtoArchivo.setNombreArchivo(resultSet.getString(6));
				segtoArchivo.setTipoDocumentoID(resultSet.getString(7));
				segtoArchivo.setComentaAdjunto(resultSet.getString(8));
				segtoArchivo.setDescTipoDocumento(resultSet.getString(9));
				return segtoArchivo;
			}
		});
		listaAclaraArchivos= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista archivos de las aclaraciones", e);
		}
		return listaAclaraArchivos;
	}
}