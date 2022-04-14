package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import herramientas.Constantes;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import soporte.bean.InstrumentosArchivosBean;
import soporte.dao.InstrumentosArchivosDAO;
import soporte.dao.InstrumentosArchivosDAO.Enum_TipoInstrumentos;


import credito.bean.CreditosArchivoBean;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CreditoArchivoDAO extends BaseDAO{
	InstrumentosArchivosDAO instrumentosArchivosDAO = null;
	/* Alta de Archivo o Documento Digitalizado de Credito	 */
	public MensajeTransaccionArchivoBean altaArchivosCredito(final CreditosArchivoBean archivo) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		transaccionDAO.generaNumeroTransaccion();
				mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
			mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					 new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CREDITOARCHIVOSALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(archivo.getCreditoID()));
							sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(archivo.getTipoDocumentoID()));
							sentenciaStore.setString("Par_Comentario",archivo.getComentario());
							sentenciaStore.setString("Par_Recurso",archivo.getRecurso());
							sentenciaStore.setString("Par_Extension",archivo.getExtension());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","CreditoArchivoDAO");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString(4));
								mensajeTransaccionArchivoBean.setRecursoOrigen(resultadosStore.getString(5));

							}else{
								mensajeTransaccionArchivoBean.setNumero(999);
								mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccionArchivoBean;
						}
					}
					);

				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionArchivoBean();
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
				transaction.setRollbackOnly();
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de archivo de credito ", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}

	/* Baja de Archivo o Documento Digitalizado de Credito	 */
	public MensajeTransaccionArchivoBean bajaArchivosCredito(final CreditosArchivoBean archivo, final int tipoBaja) {

		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();

		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();

				try {

			mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					 new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call CREDITOARCHIVOSBAJ(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(archivo.getCreditoID()));
							sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(archivo.getTipoDocumentoID()));
							sentenciaStore.setInt("Par_DigCreditoID",Utileria.convierteEntero(archivo.getDigCreaID()));
							sentenciaStore.setInt("Par_TipoBaja",tipoBaja);

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","CreditoArchivoDAO");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
					        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
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
					}
					);

				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionArchivoBean();
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
				transaction.setRollbackOnly();
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de archivos de credito", e);

			}
			return mensajeBean;
		}
	});
	return mensaje;
}
	/* Lista de Archivos por Credito*/
	public List listaArchivosCredito(CreditosArchivoBean archivoBean, int tipoLista) {
		// TODO Auto-generated method stub
		String query = "call CREDITOARCHIVOSLIS (?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros ={

				archivoBean.getCreditoID(),
				archivoBean.getTipoDocumentoID(),
				archivoBean.getComentario(),
				archivoBean.getRecurso(),
				archivoBean.getFechaActual(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditoArchivoDAO.listaArchivosCred",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOARCHIVOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosArchivoBean archivoBean = new CreditosArchivoBean();
				archivoBean.setCreditoID(resultSet.getString("CreditoID"));
				archivoBean.setComentario(resultSet.getString("Comentario"));
				archivoBean.setRecurso(resultSet.getString("Recurso"));
				archivoBean.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
				archivoBean.setTipoDocumento(resultSet.getString("Descripcion"));

				return archivoBean;
			}
		});


		return matches;

	}

	/* Lista de Archivos de Credito por tipo de documento*/

	public List listaArchivosCreditoTipoDoc(CreditosArchivoBean creditosArchivoBean, int tipoLista) {
		// TODO Auto-generated method stub
		String query = "call CREDITOARCHIVOSLIS (?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros ={

				creditosArchivoBean.getCreditoID(),
				creditosArchivoBean.getTipoDocumentoID(),
				creditosArchivoBean.getComentario(),
				creditosArchivoBean.getRecurso(),
				creditosArchivoBean.getFechaActual(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditoArchivoDAO.listaArchivosCreditoTipoDoc",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOARCHIVOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosArchivoBean archivoBean = new CreditosArchivoBean();
				archivoBean.setDigCreaID(String.valueOf(resultSet.getInt(1)));
				archivoBean.setCreditoID(resultSet.getString(2));
				archivoBean.setTipoDocumentoID(resultSet.getString(3));
				archivoBean.setRecurso(resultSet.getString(6));
				archivoBean.setComentario(resultSet.getString(5));
				archivoBean.setDescTipoDoc(resultSet.getString("Descripcion"));

				return archivoBean;
			}
		});


		return matches;
	}
	//Consulta para saber cuantos documentos digitalizados tiene el credito
	public CreditosArchivoBean consultaCantDocumentos(CreditosArchivoBean archivo, int tipoConsulta) {
		CreditosArchivoBean creditosArchivoBeanConsulta = new CreditosArchivoBean();
		try{
			//Query con el Store Procedure
			String query = "call CREDITOARCHIVOSCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {archivo.getCreditoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CreditoArchivoDAO.consultaCantDocumentos",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOARCHIVOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosArchivoBean archivo = new CreditosArchivoBean();
						archivo.setNumeroDocumentos(String.valueOf(resultSet.getInt(1)));
						return archivo;

				}

			});

			creditosArchivoBeanConsulta =  matches.size() > 0 ? (CreditosArchivoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de archivos de credito", e);
		}
		return creditosArchivoBeanConsulta;
	}

	public MensajeTransaccionArchivoBean procBajaArchivosCredito(final CreditosArchivoBean archivo,final int tipoBaja) {
		MensajeTransaccionArchivoBean mensaje = null;

		final InstrumentosArchivosBean instrumArchivo = new InstrumentosArchivosBean();

		instrumArchivo.setArchivoBajID(archivo.getDigCreaID());
		instrumArchivo.setNumeroInstrumento(archivo.getCreditoID());
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
						mensajeBean = instrumentosArchivosDAO.altaArchivosAEliminar(instrumArchivo,Enum_TipoInstrumentos.credito);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						mensajeBean = bajaArchivosCredito(archivo,tipoBaja);
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Archivos Eliminados de Credito.", e);
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
