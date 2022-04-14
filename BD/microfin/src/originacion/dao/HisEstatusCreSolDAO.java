
package originacion.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import originacion.bean.HisEstatusCreSolBean;

import javax.sql.DataSource;

import tesoreria.bean.DistCCInvBancariaBean;

public class HisEstatusCreSolDAO extends BaseDAO{

	public HisEstatusCreSolDAO(){
		super();
	}
	/* metodo de lista para obtener los datos para el reporte */
	public List<HisEstatusCreSolBean> listaReporte(final HisEstatusCreSolBean hisEstatusCreSolBean){	
		List<HisEstatusCreSolBean> ListaResultado=null;
		int tipoReporte = 1;
		try{
		String query = "CALL HISESTATUSSOLCREREP( ?,?,?,?,?," +
												" ?,?,?)";
		Object[] parametros ={						
				Utileria.convierteEntero(hisEstatusCreSolBean.getSolicitudCreID()),							

	    		parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL HISESTATUSSOLCREREP(  " + Arrays.toString(parametros) + ");");
		List<HisEstatusCreSolBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				HisEstatusCreSolBean hisEstatusBean= new HisEstatusCreSolBean();
				
				hisEstatusBean.setEstatusSolCreID(resultSet.getString("EstatusSolCreID"));
				hisEstatusBean.setHoraActualizacion(resultSet.getString("HoraActualizacion"));
				hisEstatusBean.setFecha(resultSet.getString("Fecha"));
				hisEstatusBean.setUsuarioAct(resultSet.getString("UsuarioID"));
				hisEstatusBean.setEstatus(resultSet.getString("Estatus"));
				hisEstatusBean.setMotivoRechazoID(resultSet.getString("MotivoRechazoID"));
				hisEstatusBean.setComentario(resultSet.getString("Comentario"));
				hisEstatusBean.setNombreEstatus(resultSet.getString("NombreEstatus"));
				hisEstatusBean.setUsuario(resultSet.getString("Usuario"));
				hisEstatusBean.setMotivoRechazo(resultSet.getString("MotivoRechazo"));

				
				return hisEstatusBean ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reporte de historico de las solicitud de credito: ", e);
		}
		return ListaResultado;
	}// fin lista report 



}

