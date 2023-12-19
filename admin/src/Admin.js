
import AdminPanelSettingsIcon from '@mui/icons-material/AdminPanelSettings';
import * as React from 'react';
import Box from '@mui/material/Box';
import CssBaseline from '@mui/material/CssBaseline';
import Drawer from '@mui/material/Drawer';

import { Toolbar, ToggleButton, ToggleButtonGroup } from '@mui/material';
import BlockUser from './blockUser';
import ApproveAccounts from './ApproveAccounts';
import AddToMaps from './AddToMaps';
import Emergency from './Emergency';
import DeletePost from './deletePost';
import ApproveConfessions from './ApproveConfessions';
import UnBlockUser from './UnBlockUser';

const drawerWidth = 260;

function Admin(props) {
    const { window } = props;
    const [MaterialBody, setMaterialBody] = React.useState(<ApproveAccounts />)
    const [alignment, setAlignment] = React.useState('web');

    const handleChange = (event, newAlignment) => {
        if (newAlignment !== null)
            setAlignment(newAlignment);
        switch (event.target.value) {
            case 'accounts':
                setMaterialBody(<ApproveAccounts />)
                break;
            case 'maps':
                setMaterialBody(<AddToMaps />)
                break;
            case 'emergency':
                setMaterialBody(<Emergency />)
                break;
            case 'delete':
                setMaterialBody(<DeletePost />)
                break;
            case 'block':
                setMaterialBody(<BlockUser />)
                break;
            case 'unblock':
                setMaterialBody(<UnBlockUser />)
                break;
            case 'confessions':
                setMaterialBody(<ApproveConfessions />)
                break;
            default:
                break;
        }
    };


    const drawer = (
        <div>
            <AdminPanelSettingsIcon sx={{ width: { sm: drawerWidth }, fontSize: { sm: '50px' } }} />
            <ToggleButtonGroup
                size="large"
                fullWidth={true}
                orientation='vertical'
                color="primary"
                value={alignment}
                exclusive
                onChange={handleChange}
                aria-label="Platform"
            >
                <ToggleButton className="admin-toggle-button" value="accounts">Approve Accounts</ToggleButton>
                <ToggleButton className="admin-toggle-button" value="confessions">Approve Confessions</ToggleButton>
                <ToggleButton className="admin-toggle-button" value="maps">Add Location To Maps</ToggleButton>
                <ToggleButton className="admin-toggle-button" value="emergency">Add Emergency Phone Numbers</ToggleButton>
                <ToggleButton className="admin-toggle-button" value="delete">Delete Post</ToggleButton>
                <ToggleButton className="admin-toggle-button" value="block">Block User</ToggleButton>
                <ToggleButton className="admin-toggle-button" value="unblock">Unblock User</ToggleButton>
            </ToggleButtonGroup>
        </div>
    );

    return (
        <Box sx={{ display: 'flex' }}>
            <CssBaseline />
            <Box
                component="nav"
                sx={{ width: { sm: drawerWidth }, flexShrink: { sm: 0 } }}
                aria-label="mailbox folders"
            >
                <Drawer
                    variant="permanent"
                    sx={{
                        display: { xs: 'none', sm: 'block' },
                        '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
                    }}
                    open
                >
                    {drawer}
                </Drawer>
            </Box>
            <Box
                component="main"
                sx={{ flexGrow: 1, p: 3, width: { sm: `calc(100% - ${drawerWidth}px)` } }}
            >
                <Toolbar />
                {MaterialBody}
            </Box>
        </Box >
    );
}


export default Admin;
