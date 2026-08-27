import { Plugin } from '@/types/plugin';
import p_0 from '@plugins/dev/contenttypefixture';
import p_1 from '@plugins/english/projectgutenberg';
import p_2 from '@plugins/english/standardebooks';
import p_3 from '@plugins/japanese/aozorabunko';
import p_4 from '@plugins/japanese/ndlnextdigitallibrary';
import p_5 from '@plugins/multi/githubdocs';
import p_6 from '@plugins/multi/komga';
import p_7 from '@plugins/multi/oapen';
import p_8 from '@plugins/multi/peppercarrot';

const PLUGINS: Plugin.PluginBase[] = [
  p_0,
  p_1,
  p_2,
  p_3,
  p_4,
  p_5,
  p_6,
  p_7,
  p_8,
];
export default PLUGINS;
