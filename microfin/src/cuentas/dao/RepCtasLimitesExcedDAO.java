package cuentas.dao;

	import general.bean.MensajeTransaccionBean;
	import general.dao.BaseDAO;
	import herramientas.Constantes;
	import herramientas.Utileria;

	import java.sql.CallableStatement;
	import java.sql.Connection;
	import java.sql.ResultSet;
	import java.sql.SQLException;
	import java.sql.Types;
	import java.util.Arrays;
	import java.util.List;

	import org.springframework.dao.DataAccessException;
	import org.springframework.jdbc.core.CallableStatementCallback;
	import org.springframework.jdbc.core.CallableStatementCreator;
	import org.springframework.jdbc.core.RowMapper;
	import org.springframework.jdbc.core.JdbcTemplate;
	import org.springframework.transaction.support.TransactionTemplate;
	import org.springframework.transaction.TransactionStatus;
	import org.springframework.transaction.support.TransactionCallback;


	import cuentas.bean.RepCtasLimitesExcedBean;
	import general.bean.ParametrosSesionBean;

	public class RepCtasLimitesExcedDAO extends BaseDAO {
		ParametrosSesionBean parametrosSesionBean;
		
		public RepCtasLimitesExcedDAO(){
			super();
		}



		/*=============================== METODOS ==================================*/

	
		/* metodo de lista para obtener los datos para el reporte */
	  public List listaReporte(final RepCtasLimitesExcedBean solicitudAEBean, int tipoReporte){	
			List ListaResultado=null;
			
			try{
			String query = "CALL LIMEXCUENTASREP(?,?,?,?,?,  ?,?,?,?,?, ?,?)";

			Object[] parametros ={
								Utileria.convierteFecha(solicitudAEBean.getFechaInicio()),
								Utileria.convierteFecha(solicitudAEBean.getFechaFin()),
								solicitudAEBean.getSucursalID(),
								solicitudAEBean.getMotivo(),
								tipoReporte,							
					    		
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL LIMEXCUENTASREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepCtasLimitesExcedBean repCtasLimitesExcedBean= new RepCtasLimitesExcedBean();
					
					repCtasLimitesExcedBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					repCtasLimitesExcedBean.setDescripcion(resultSet.getString("Descripcion"));
					repCtasLimitesExcedBean.setFecha(resultSet.getString("Fecha"));
					repCtasLimitesExcedBean.setNombreSucurs(resultSet.getString("NombreSucurs"));
					repCtasLimitesExcedBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					repCtasLimitesExcedBean.setMotivo(resultSet.getString("Motivo"));
					
					repCtasLimitesExcedBean.setCanal(resultSet.getString("Canal"));
					return repCtasLimitesExcedBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Apoyo Escolar", e);
			}
			return ListaResultado;
		}// fin lista report 
		

		public ParametrosSesionBean getParametrosSesionBean() {
			return parametrosSesionBean;
		}

		public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
			this.parametrosSesionBean = parametrosSesionBean;
		}



	}// fin clase

