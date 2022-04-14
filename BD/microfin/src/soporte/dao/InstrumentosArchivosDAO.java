package soporte.dao;


import general.bean.MensajeTransaccionArchivoBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.InstrumentosArchivosBean;

public class InstrumentosArchivosDAO extends BaseDAO{
	// Tipos Instrumentos Tabla TIPOINSTRUMENTOS
	public static interface Enum_TipoInstrumentos {
		int cliente 			= 4;
		int prospecto			= 32;
		int cuenta				= 2;
		int solCred				= 33;
		int credito				= 11;
	}
	public InstrumentosArchivosDAO() {
		super();
		// TODO Auto-generated constructor stub
	}


	/* Alta de Archivos de Instrumentos */
	public MensajeTransaccionArchivoBean altaArchivosAEliminar(final InstrumentosArchivosBean archivo, final int tipoInstrumento) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
				mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call BITACORARCHIVOSBAJALT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_ArchivoBajID",Utileria.convierteLong(archivo.getArchivoBajID()));
							sentenciaStore.setInt("Par_TipoInstrumento",tipoInstrumento);
							sentenciaStore.setLong("Par_NumeroInstrumento",Utileria.convierteLong(archivo.getNumeroInstrumento()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString(4));
							}else{
								mensajeTransaccionArchivoBean.setNumero(999);
								mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccionArchivoBean;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionArchivoBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Archivos Eliminados de los Instrumentos" + e);
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

}
