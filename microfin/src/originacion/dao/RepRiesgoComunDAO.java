
package originacion.dao;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import originacion.bean.RepRiesgoComunBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class RepRiesgoComunDAO extends BaseDAO{

	public RepRiesgoComunDAO () {
		super();
	}
	
	/* metodo de lista para obtener los datos para el reporte de inscriptos y preinscritos */
	  public List listaReporte(final RepRiesgoComunBean repRiesgoComunBean, int tipoReporte){	
			List ListaResultado=null;
			
			try{
			String query = "CALL RIESGOCOMUNCLICREREP(?,?,?,?,?,?, ?,?,?,?,?,?,?)";

			Object[] parametros ={ 
								repRiesgoComunBean.getNumeroCliente(),
								repRiesgoComunBean.getEstatus(),
								repRiesgoComunBean.getRiesgoComun(),
								repRiesgoComunBean.getPersRelacionada(),
								repRiesgoComunBean.getProcesado(),
								repRiesgoComunBean.getSucursalSolCredID(),
				    		
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL RIESGOCOMUNCLICREREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepRiesgoComunBean repRiesgoComunBean= new RepRiesgoComunBean();

					repRiesgoComunBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					repRiesgoComunBean.setClienteIDRel(resultSet.getString("ClienteID"));
					repRiesgoComunBean.setNombreClienteRel(resultSet.getString("NombreCompleto"));
					repRiesgoComunBean.setClienteID(resultSet.getString("ClienteIDRel"));
					repRiesgoComunBean.setNombreCliente(resultSet.getString("NombreCompletoRel"));

					repRiesgoComunBean.setCreditoID(resultSet.getString("CreditoID"));
					repRiesgoComunBean.setMotivo(resultSet.getString("Motivo"));
					repRiesgoComunBean.setRiesgoComun(resultSet.getString("RiesgoComun"));
					repRiesgoComunBean.setPersRelacionada(resultSet.getString("PersRelacionada"));
					repRiesgoComunBean.setProcesado(resultSet.getString("Procesado"));

					repRiesgoComunBean.setComentario(resultSet.getString("Comentario"));
					repRiesgoComunBean.setParentesco(resultSet.getString("Descripcion"));
					repRiesgoComunBean.setClave(resultSet.getString("Clave"));
					repRiesgoComunBean.setEstatus(resultSet.getString("Estatus"));
					repRiesgoComunBean.setMontoAcumulado(resultSet.getString("MontoAcumulado"));
					
					repRiesgoComunBean.setSucursalSolCredID(resultSet.getString("SucursalID"));
					repRiesgoComunBean.setSucursalSolCredNombre(resultSet.getString("NombreSucurs"));

					return repRiesgoComunBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Riesgos", e);
			}
			return ListaResultado;
		}// fin lista report 		
	


}
