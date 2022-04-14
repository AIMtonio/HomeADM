package arrendamiento.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import arrendamiento.bean.SubCtaMonedaArrendaBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SubCtaMonedaArrendaDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	Logger log = Logger.getLogger( this.getClass() );

	public SubCtaMonedaArrendaDAO() {
		super();
	}

	/* Alta de sub cuenta de tipo de arrendamiento  */
	public MensajeTransaccionBean alta(final SubCtaMonedaArrendaBean subCtaMonedaArrendaBean) {
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
							String query = "call SUBCTAMONEDARRENDAALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?);";

		       				CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConceptoArrendaID",Utileria.convierteEntero(subCtaMonedaArrendaBean.getConceptoArrendaID()));
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(subCtaMonedaArrendaBean.getMonedaID()));
							sentenciaStore.setString("Par_SubCuenta",subCtaMonedaArrendaBean.getSubCuenta());
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
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
				},new CallableStatementCallback() {
					public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
							mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " SubCtaMonedaArrenda.alta");
							mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
							mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
						}
						return mensajeTransaccion;
					}
				});
				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception(Constantes.MSG_ERROR + " SubCtaMonedaArrenda.alta");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}
			} catch (Exception e) {
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de SubCtaMonedaArrenda" + e);
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
	// FIN ALTA


	/* Alta de sub cuenta de tipo de arrendamiento  */
	public MensajeTransaccionBean modifica(final SubCtaMonedaArrendaBean subCtaMonedaArrendaBean) {
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
							String query = "call SUBCTAMONEDARRENDAMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?);";

		       				CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConceptoArrendaID",Utileria.convierteEntero(subCtaMonedaArrendaBean.getConceptoArrendaID()));
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(subCtaMonedaArrendaBean.getMonedaID()));
							sentenciaStore.setString("Par_SubCuenta",subCtaMonedaArrendaBean.getSubCuenta());
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
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
				},new CallableStatementCallback() {
					public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
							mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " SubCtaMonedaArrenda.MODIFICACION");
							mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
							mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
						}
						return mensajeTransaccion;
					}
				});
				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception(Constantes.MSG_ERROR + " SubCtaMonedaArrenda.MODIFICACION");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}
			} catch (Exception e) {
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en MODIFICACION de SubCtaMonedaArrenda" + e);
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
	// FIN MODIFICA


	/* Alta de sub cuenta de tipo de arrendamiento  */
	public MensajeTransaccionBean baja(final SubCtaMonedaArrendaBean subCtaMonedaArrendaBean) {
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
							String query = "call SUBCTAMONEDARRENDABAJ(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?);";

		       				CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConceptoArrendaID",Utileria.convierteEntero(subCtaMonedaArrendaBean.getConceptoArrendaID()));
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(subCtaMonedaArrendaBean.getMonedaID()));
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
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
				},new CallableStatementCallback() {
					public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
							mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " SubCtaMonedaArrenda.baja");
							mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
							mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
						}
						return mensajeTransaccion;
					}
				});
				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception(Constantes.MSG_ERROR + " SubCtaMonedaArrenda.baja");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}
			} catch (Exception e) {
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en baja de SubCtaMonedaArrenda" + e);
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
	// FIN baja

	/* PARA OBTENER LA CONSULTA PRINCIPAL  */
	public SubCtaMonedaArrendaBean consultaPrincipal(SubCtaMonedaArrendaBean subCtaMonedaArrendaBean, int tipoConsulta) {
		SubCtaMonedaArrendaBean result = null;
		try{
			// Query con el Store Procedure
			String query = "call SUBCTAMONEDARRENDACON(" +
					"?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteLong(subCtaMonedaArrendaBean.getConceptoArrendaID()),
					Utileria.convierteLong(subCtaMonedaArrendaBean.getMonedaID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"ArrendamientosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTAMONEDARRENDACON( " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					SubCtaMonedaArrendaBean arrendaBean = new SubCtaMonedaArrendaBean();
					arrendaBean.setConceptoArrendaID(resultSet.getString("ConceptoArrendaID"));
					arrendaBean.setMonedaID(resultSet.getString("MonedaID"));
					arrendaBean.setSubCuenta(resultSet.getString("SubCuenta"));
				    return arrendaBean;
				}
			});
			result =  matches.size() > 0 ? (SubCtaMonedaArrendaBean) matches.get(0) : null;
		}catch(Exception e ){
			e.printStackTrace();
		}
		return result;
	}

}
