
package originacion.dao;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import originacion.bean.RepBitacoraSolBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class RepBitacoraSolDAO extends BaseDAO{

	public RepBitacoraSolDAO () {
		super();
	}
	
	/* metodo de lista para obtener los datos para el reporte de inscriptos y preinscritos */
	  public List listaReporte(final RepBitacoraSolBean repBitacoraSolBean, int tipoReporte){	
			List ListaResultado=null;
			
			try{
			String query = "CALL BITACORASOLCREDREP(?,?,?,?,?,?, ?,?,?,?,?, ?,?)";

			Object[] parametros ={ 
								repBitacoraSolBean.getFechaInicio(),
								repBitacoraSolBean.getFechaFin(),
								repBitacoraSolBean.getSucursalID(),
								repBitacoraSolBean.getPromotorID(),																
								repBitacoraSolBean.getProducCreditoID(),
								repBitacoraSolBean.getEsAgropecuario(),
				    		
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL BITACORASOLCREDREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepBitacoraSolBean repBitacoraSolBean= new RepBitacoraSolBean();
					
					repBitacoraSolBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					repBitacoraSolBean.setCreditoID(resultSet.getString("CreditoID"));
					repBitacoraSolBean.setClienteID(resultSet.getString("ClienteID"));
					repBitacoraSolBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					repBitacoraSolBean.setPromotor(resultSet.getString("PromotorID"));
					repBitacoraSolBean.setNomPromotor(resultSet.getString("NombrePromotor"));
					repBitacoraSolBean.setEstatus(resultSet.getString("Estatus"));
					
					repBitacoraSolBean.setFechaSolRegistro(resultSet.getString("FechaSolRegistro"));
					repBitacoraSolBean.setUsuSolRegistro(resultSet.getString("UsuSolRegistro"));
					repBitacoraSolBean.setNomUsuSolRegistro(resultSet.getString("NomUsuSolRegistro"));
					repBitacoraSolBean.setComSolRegistro(resultSet.getString("ComSolRegistro"));
					repBitacoraSolBean.setTiempoEstRegistro(resultSet.getString("TiempoEstRegistro"));

					repBitacoraSolBean.setFechaSolActualiza(resultSet.getString("FechaSolActualizacion"));
					repBitacoraSolBean.setUsuSolActualiza(resultSet.getString("UsuSolActualizacion"));
					repBitacoraSolBean.setNomUsuSolActualiza(resultSet.getString("NomUsuSolActualizacion"));
					repBitacoraSolBean.setComSolActualiza(resultSet.getString("ComSolActualizacion"));
					repBitacoraSolBean.setTiempoEstActualiza(resultSet.getString("TiempoEstActualizacion"));
					
					repBitacoraSolBean.setFechaSolRechaza(resultSet.getString("FechaSolRechazo"));
					repBitacoraSolBean.setUsuSolRechaza(resultSet.getString("UsuSolRechazo"));
					repBitacoraSolBean.setNomUsuSolRechaza(resultSet.getString("NomUsuSolRechazo"));
					repBitacoraSolBean.setComSolRechaza(resultSet.getString("ComSolRechazo"));
					
					repBitacoraSolBean.setFechaSolLibera(resultSet.getString("FechaSolLiberacion"));
					repBitacoraSolBean.setUsuSolLibera(resultSet.getString("UsuSolLiberacion"));
					repBitacoraSolBean.setNomUsuSolLibera(resultSet.getString("NomUsuSolLiberacion"));
					repBitacoraSolBean.setComSolLibera(resultSet.getString("ComSolLiberacion"));
					repBitacoraSolBean.setTiempoEstLibera(resultSet.getString("TiempoEstLiberacion"));

					repBitacoraSolBean.setFechaSolAutoriza(resultSet.getString("FechaSolAutorizacion"));
					repBitacoraSolBean.setUsuSolAutoriza(resultSet.getString("UsuSolAutorizacion"));
					repBitacoraSolBean.setNomUsuSolAutoriza(resultSet.getString("NomUsuSolAutorizacion"));
					repBitacoraSolBean.setComSolAutoriza(resultSet.getString("ComSolAutorizacion"));
					repBitacoraSolBean.setTiempoEstAutoriza(resultSet.getString("TiempoEstAutorizacion"));
					
					repBitacoraSolBean.setFechaCreRegistro(resultSet.getString("FechaCreRegistro"));
					repBitacoraSolBean.setUsuCreRegistro(resultSet.getString("UsuCreRegistro"));
					repBitacoraSolBean.setNomUsuCreRegistro(resultSet.getString("NomUsuCreRegistro"));
					repBitacoraSolBean.setComCreRegistro(resultSet.getString("ComCreRegistro"));
					repBitacoraSolBean.setTiempoEstCreRegistro(resultSet.getString("TiempoEstCreRegistro"));
					
					repBitacoraSolBean.setFechaCreCondiciona(resultSet.getString("FechaCreCondiciona"));
					repBitacoraSolBean.setUsuCreCondiciona(resultSet.getString("UsuCreCondiciona"));
					repBitacoraSolBean.setNomUsuCreCondiciona(resultSet.getString("NomUsuCreCondiciona"));
					repBitacoraSolBean.setComCreCondiciona(resultSet.getString("ComCreCondiciona"));
					repBitacoraSolBean.setTiempoEstCreCondiciona(resultSet.getString("TiempoEstCreCondiciona"));
					
					repBitacoraSolBean.setFechaCreAutoriza(resultSet.getString("FechaCreAutoriza"));
					repBitacoraSolBean.setUsuCreAutoriza(resultSet.getString("UsuCreAutoriza"));
					repBitacoraSolBean.setNomUsuCreAutoriza(resultSet.getString("NomUsuCreAutoriza"));
					repBitacoraSolBean.setComCreAutoriza(resultSet.getString("ComCreAutoriza"));
					repBitacoraSolBean.setTiempoEstCreAutoriza(resultSet.getString("TiempoEstCreAutoriza"));
					
					repBitacoraSolBean.setFechaCreDesembolsa(resultSet.getString("FechaCreDesembolsa"));
					repBitacoraSolBean.setUsuCreDesembolsa(resultSet.getString("UsuCreDesembolsa"));
					repBitacoraSolBean.setNomUsuCreDesembolsa(resultSet.getString("NomUsuCreDesembolsa"));
					repBitacoraSolBean.setComCreDesembolsa(resultSet.getString("ComCreDesembolsa"));
					
					repBitacoraSolBean.setFechaCreCancela(resultSet.getString("FechaCreCancela"));
					repBitacoraSolBean.setUsuCreCancela(resultSet.getString("UsuCreCancela"));
					repBitacoraSolBean.setNomUsuCreCancela(resultSet.getString("NomUsuCreCancela"));
					repBitacoraSolBean.setComCreCancela(resultSet.getString("ComCreCancela"));
					repBitacoraSolBean.setHoraEmision(resultSet.getString("HoraEmision"));
					repBitacoraSolBean.setDias(resultSet.getString("Dias"));
					
					
					return repBitacoraSolBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Asambleas", e);
			}
			return ListaResultado;
		}// fin lista report 		
	


}