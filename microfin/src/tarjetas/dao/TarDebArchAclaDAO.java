package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import credito.bean.CalPorRangoBean;


import soporte.bean.CuentaArchivosBean;
import tarjetas.bean.TarDebAclaraBean;
import tarjetas.bean.TarDebArchAclaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class TarDebArchAclaDAO  extends BaseDAO{
	public TarDebArchAclaDAO() {
		super();
	}
	public MensajeTransaccionBean grabaListaAclaraArch(final TarDebArchAclaBean tarDebArchAclaBean, final List listaArchAdjuntos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				MensajeTransaccionBean mensajeBeanSalida = new MensajeTransaccionBean();
				try {
					TarDebArchAclaBean rangoArchivosBean;
					mensajeBean = bajaAclaraArchivos(tarDebArchAclaBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaArchAdjuntos.size(); i++){
						rangoArchivosBean = (TarDebArchAclaBean)listaArchAdjuntos.get(i);
						mensajeBean = altaAclaraArchivos(rangoArchivosBean);
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
	public MensajeTransaccionBean altaAclaraArchivos(final TarDebArchAclaBean tarDebArchAclaBean) {
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
									String query = "call TARDEBARCHACLARAALT(?,?,?,?, ?,?,?,   ?,?,?,?,  ?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_FolioID",Utileria.convierteEntero(tarDebArchAclaBean.getFolioID()));
									sentenciaStore.setString("Par_ReporteID",tarDebArchAclaBean.getReporteID());
									sentenciaStore.setString("Par_TipoArchivo",tarDebArchAclaBean.getTipoArchivo());
									sentenciaStore.setString("Par_Recurso",tarDebArchAclaBean.getRuta());
									sentenciaStore.setString("Par_NombreArchivo",tarDebArchAclaBean.getNombreArchivo());

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
							}// CallableStatementCallback
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de la aclaracion",
									e);
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
	public MensajeTransaccionBean bajaAclaraArchivos(TarDebArchAclaBean tarDebArchAclaBean) {
		String query = "call TARDEBARCHACLARABAJ(?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
				tarDebArchAclaBean.getReporteID(),


				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"bajaAclaraArchivos",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBARCHACLARABAJ(  " + Arrays.toString(parametros) + ")");

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
		/* Lista de archivos de aclaraciones*/
	public List listaAclaraArchivos(TarDebArchAclaBean tarDebArchAclaBean, int tipoLista) {
		List listaAclaraArchivos=null;
		try{
		String query = "call TARDEBARCHACLARALIS(?,?,?,  ?,?,? ,  ?,?,?);";
		Object[] parametros = {
								tarDebArchAclaBean.getReporteID(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TarDebArchAclaDAO.listaAclaraArchivos",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBARCHACLARALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarDebArchAclaBean tarjetaArchivoAclara = new TarDebArchAclaBean();
				tarjetaArchivoAclara.setFolioID(resultSet.getString(1));
				tarjetaArchivoAclara.setTipoArchivo(resultSet.getString(2));
				tarjetaArchivoAclara.setRuta(resultSet.getString(3));
				tarjetaArchivoAclara.setFechaRegistro(resultSet.getString(4));
				tarjetaArchivoAclara.setNombreArchivo(resultSet.getString(5));
				return tarjetaArchivoAclara;
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

