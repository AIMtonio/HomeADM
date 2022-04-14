package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
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

import contabilidad.bean.ConceptoBalanzaBean;

public class ConceptoBalanzaDAO extends BaseDAO{
	
	public ConceptoBalanzaDAO() {
		super();
	}
	
	public List listaAlfanumerica(ConceptoBalanzaBean conceptoBalanzaBean, int tipoLista){
	String query = "call CONCEPTOBALANZALIS(?,? ,?,?,?,?,?,?,?);";
	Object[] parametros = {
				conceptoBalanzaBean.getDescripcion(),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ConceptoBalanzaDAO.listaAlfanumerica",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOBALANZALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			ConceptoBalanzaBean conceptoBalanzaBean = new ConceptoBalanzaBean();
			conceptoBalanzaBean.setConBalanzaID(resultSet.getString(1));
			conceptoBalanzaBean.setDescripcion(resultSet.getString(2));
			return conceptoBalanzaBean;
			
		}
	});
	return matches;
	}
	
	public ConceptoBalanzaBean consultaForanea(ConceptoBalanzaBean conceptoBalanza, int tipoConsulta){
		String query = "call CONCEPTOBALANZACON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				conceptoBalanza.getConBalanzaID(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConceptoBalanzaDAO.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOBALANZACON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptoBalanzaBean conceptoBalanza = new ConceptoBalanzaBean();
				conceptoBalanza.setConBalanzaID(resultSet.getString(1));
				conceptoBalanza.setDescripcion(resultSet.getString(2));
				return conceptoBalanza;
			}
		});
		return matches.size() > 0 ? (ConceptoBalanzaBean) matches.get(0) : null;
	}
	
	/*------------Alta de Conceptos Balanza-------------*/
	
	public MensajeTransaccionBean alta(final ConceptoBalanzaBean conceptoBalanzaBean) {
		

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				
/*---------------Query con el SP-------------*/
				String query = "call CONCEPTOBALANZAALT(?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
						
						conceptoBalanzaBean.getConBalanzaID(),
						conceptoBalanzaBean.getDescripcion(),	
																
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOBALANZAALT(" + Arrays.toString(parametros) + ")");
		
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
			} catch (Exception e) {
				if(mensajeBean.getNumero()==0){
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de conceptode balanza", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}
	
	/* Modificacion del Concepto */
	public MensajeTransaccionBean modifica(final ConceptoBalanzaBean conceptoBalanza) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					
					//Query cons el Store Procedure
					String query = "call CONCEPTOBALANZAMOD(?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {	
	
					conceptoBalanza.getConBalanzaID(),
					conceptoBalanza.getDescripcion(),
					
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOBALANZAMOD(" + Arrays.toString(parametros) + ")");
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de conceptos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	/*-------Baja de concepto-------*/
	
	public MensajeTransaccionBean  baja(final ConceptoBalanzaBean conceptoBalanza) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
	/*--------Baja con SP---------*/
					String query = "call CONCEPTOBALANZABAJ(?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							conceptoBalanza.getConBalanzaID(),
							conceptoBalanza.getDescripcion(),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOBALANZABAJ(" + Arrays.toString(parametros) + ")");
					
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de conceptos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
}
