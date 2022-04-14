package cliente.dao;
 
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import javax.sql.DataSource;

import cliente.bean.DireccionesClienteBean;
import cliente.bean.GruposEmpBean;



public class GruposEmpDAO extends BaseDAO{

	public GruposEmpDAO() {
		super();
	}

	
	// ------------------ Transacciones ------------------------------------------


	public MensajeTransaccionBean altaGrupoEmp(final GruposEmpBean empresa) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call GRUPOSEMPALT(?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							empresa.getNombreGrupo(),
							empresa.getObservacion(),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"GruposEmpDAO.altaGrupoEmp",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSEMPALT(" + Arrays.toString(parametros) + ")");
			
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
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de grupo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	
	public MensajeTransaccionBean actualizaGrupoEmp(final GruposEmpBean empresa){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call GRUPOSEMPSMOD(?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = { 
							empresa.getGrupoEmpID(),
							empresa.getNombreGrupo(),
							empresa.getObservacion(),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"GruposEmpDAO.actualizaGrupoEmp",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOEMPSMOD(" + Arrays.toString(parametros) + ")");
					
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
					
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de grupo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
		
	public GruposEmpBean ConsultaPrincipal(int GrupoEmpID, int tipoConsulta){
		String query = "call GRUPOSEMPSCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { GrupoEmpID,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GruposEmpDAO.ConsultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSEMPSCON(" + Arrays.toString(parametros) + ")");
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GruposEmpBean grupoEmp = new GruposEmpBean();
								
				grupoEmp.setGrupoEmpID(Utileria.completaCerosIzquierda(
										resultSet.getInt(1),GruposEmpBean.LONGITUD_ID));
				grupoEmp.setEmpresaID(Utileria.completaCerosIzquierda(resultSet.getLong(2), 10));				
				grupoEmp.setNombreGrupo(resultSet.getString(3));				
				grupoEmp.setObservacion(resultSet.getString(4));				
				
				return grupoEmp;
			}
		});
		
		return matches.size() > 0 ? (GruposEmpBean) matches.get(0) : null;
		
		}
	
	
	public GruposEmpBean consultaForanea(int GrupoEmpID, int tipoConsulta){
		String query = "call GRUPOSEMPSCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { GrupoEmpID,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GruposEmpDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSEMPSCON(" + Arrays.toString(parametros) + ")");
		
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GruposEmpBean grupoEmp = new GruposEmpBean();
				
				grupoEmp.setGrupoEmpID(Utileria.completaCerosIzquierda(
										resultSet.getInt(1),GruposEmpBean.LONGITUD_ID));
				grupoEmp.setNombreGrupo(resultSet.getString(2));				
				return grupoEmp;
			}
		});
		
		return matches.size() > 0 ? (GruposEmpBean) matches.get(0) : null;
		
		}
	
	public List listaGrupoEmpresa(GruposEmpBean empresa, int tipoLista){
		String query = "call GRUPOSEMPSLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	empresa.getNombreGrupo(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GruposEmpDAO.listaGrupoEmpresa",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSEMPSLIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GruposEmpBean grupoEmp = new GruposEmpBean();
				grupoEmp.setGrupoEmpID(String.valueOf(resultSet.getInt(1)));
				grupoEmp.setNombreGrupo(resultSet.getString(2));
				grupoEmp.setObservacion(resultSet.getString(3));
				return grupoEmp;
				
			}
		});
		return matches;
	}



}
